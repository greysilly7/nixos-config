#!/usr/bin/env bash

# Source colors
[ -f "$CONFIG_DIR/colors.sh" ] && source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --remove '/clock\.cal_.*/'
  
  cal_output=$(python3 -c "import re; import subprocess; import datetime; today = str(datetime.date.today().day); cal = subprocess.check_output(['cal']).decode(); out = re.sub(r'\b'+today+r'\b', ''.join(c+'\u0332' for c in today), cal); print(out)")
  
  i=0
  args=()
  while IFS= read -r line; do
    sketchybar --add item clock.cal_$i popup.clock
    
    args+=(--set clock.cal_$i icon.drawing=off \
                              label="$line" \
                              label.font="Hack Nerd Font:Regular:14.0" \
                              label.padding_left=10 \
                              label.padding_right=10 \
                              label.color=$TEXT)
    i=$((i+1))
  done <<< "$cal_output"
  sketchybar "${args[@]}" --set clock popup.drawing=on
elif [ "$SENDER" = "mouse.exited" ] || [ "$SENDER" = "mouse.exited.global" ]; then
  sketchybar --set clock popup.drawing=off
else
  sketchybar --set $NAME label="$(date '+%I:%M %p')"
fi

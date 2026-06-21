#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

BATT_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [[ $CHARGING != "" ]]; then
  ICON="󰂄"
  COLOR=$GREEN
else
  if [[ $BATT_PERCENT -gt 80 ]]; then
    ICON="󰁹"
    COLOR=$GREEN
  elif [[ $BATT_PERCENT -gt 60 ]]; then
    ICON="󰂀"
    COLOR=$YELLOW
  elif [[ $BATT_PERCENT -gt 40 ]]; then
    ICON="󰁾"
    COLOR=$PEACH
  elif [[ $BATT_PERCENT -gt 20 ]]; then
    ICON="󰁼"
    COLOR=$MAROON
  else
    ICON="󰂃"
    COLOR=$RED
  fi
fi

sketchybar --set $NAME icon="$ICON" label="${BATT_PERCENT}%" icon.color=$COLOR

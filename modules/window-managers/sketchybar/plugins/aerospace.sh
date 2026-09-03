#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" background.drawing=on \
                       background.color="$LAVENDER" \
                       label.color="$BASE"
else
    sketchybar --set "$NAME" background.drawing=on \
                       background.color="$SURFACE1" \
                       label.color="$TEXT"
fi

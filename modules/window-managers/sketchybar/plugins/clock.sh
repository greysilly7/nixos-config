#!/usr/bin/env bash

# Source colors
[ -f "$CONFIG_DIR/colors.sh" ] && source "$CONFIG_DIR/colors.sh"

sketchybar --set "$NAME" label="$(date '+%I:%M %p')"

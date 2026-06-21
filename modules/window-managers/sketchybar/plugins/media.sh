#!/usr/bin/env bash

if [ -z "$INFO" ]; then
  exit 0
fi

STATE="$(echo "$INFO" | jq -r '.state')"
TITLE="$(echo "$INFO" | jq -r '.title')"
ARTIST="$(echo "$INFO" | jq -r '.artist')"

if [ "$STATE" = "playing" ]; then
  MEDIA="${TITLE} - ${ARTIST}"
  # Truncate if it's too long
  if [ ${#MEDIA} -gt 40 ]; then
    MEDIA="$(echo "$MEDIA" | cut -c 1-37)..."
  fi
  sketchybar --set $NAME label="$MEDIA" drawing=on
else
  sketchybar --set $NAME drawing=off
fi

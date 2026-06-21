#!/usr/bin/env bash
RAM_USAGE=$(memory_pressure | awk '/System-wide memory free percentage:/ {print 100-$5}')
sketchybar --set $NAME label="${RAM_USAGE}%"

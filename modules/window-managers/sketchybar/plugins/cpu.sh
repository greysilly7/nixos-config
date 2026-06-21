#!/usr/bin/env bash
CORE_COUNT=$(sysctl -n hw.logicalcpu)
CPU_INFO=$(ps -eo pcpu,user | awk -v cores="$CORE_COUNT" 'NR>1 {sum+=$1} END {print sum/cores}')
CPU_USAGE=$(printf "%.0f" "$CPU_INFO")
sketchybar --set $NAME label="${CPU_USAGE}%"

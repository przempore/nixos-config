#!/usr/bin/env bash

echo "[toggle_waybar] start" | systemd-cat

if pgrep -x .waybar-wrapped >/dev/null; then
  pkill -x .waybar-wrapped
else
  waybar >/dev/null 2>&1 &
fi

echo "[toggle_waybar] end" | systemd-cat

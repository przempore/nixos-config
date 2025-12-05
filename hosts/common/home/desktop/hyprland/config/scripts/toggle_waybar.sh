#!/usr/bin/env bash

echo "[toggle_waybar] start" | systemd-cat

if pgrep -x .waybar-wrapped >/dev/null; then
  echo "[toggle_waybar] stopping waybar service" | systemd-cat
  pkill -x .waybar-wrapped
else
  echo "[toggle_waybar] starting waybar service" | systemd-cat
  uwsm-app -- waybar
fi

echo "[toggle_waybar] end" | systemd-cat

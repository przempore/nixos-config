#!/usr/bin/env bash

echo "[toggle_waybar] start" | systemd-cat

state_file="$HOME/.cache/waybar_state"

# Check if the state file exists
if [ ! -f "$state_file" ]; then
    echo "visible" > "$state_file"
fi

# Read the current state
current_state=$(cat "$state_file")

# Toggle the state
if [[ "$current_state" == "visible" ]]; then
    # Hide Waybar and adjust Hyprland gaps
    killall waybar
    hyprctl keyword general:gaps_out 0
    echo "hidden" > "$state_file"
else
    # Show Waybar and adjust Hyprland gaps
    waybar &
    hyprctl keyword general:gaps_out 4
    echo "visible" > "$state_file"
fi

echo "[toggle_waybar] end" | systemd-cat

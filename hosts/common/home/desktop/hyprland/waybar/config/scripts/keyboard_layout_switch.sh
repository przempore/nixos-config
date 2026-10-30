#!/usr/bin/env bash
set -euo pipefail

active_keymap=$(
  hyprctl -j devices |
    jq -er '.keyboards | (map(select(.main)) + .) | .[0].active_keymap'
)

if [ "$active_keymap" = "English (US)" ]; then
  layouts="real-prog-dvorak,us"
else
  layouts="us,real-prog-dvorak"
fi

checked_hyprctl() {
  local response
  response=$(hyprctl "$@")
  if [ "$response" != "ok" ]; then
    printf 'hyprctl %s failed: %s\n' "$1" "$response" >&2
    return 1
  fi
}

# Rebuild the base keymap exposed to Wine, then select its first layout.
checked_hyprctl eval "hl.config({ input = { kb_layout = \"$layouts\" } })"
checked_hyprctl switchxkblayout all 0

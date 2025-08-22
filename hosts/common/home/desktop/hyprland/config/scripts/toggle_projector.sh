#!/usr/bin/env bash
set -euo pipefail

PROJECTOR="HDMI-A-2"
MAIN="HDMI-A-1"

# --- helper: read "disabled" flag for $PROJECTOR (true/false) ---
read_disabled_flag() {
  # Try JSON first (handles both array and nested objects)
  if command -v jq >/dev/null 2>&1; then
    local json
    json="$(hyprctl -j monitors all 2>/dev/null || true)"
    if [[ -n "$json" ]]; then
      # Recurse through any arrays/objects, pick object with .name==$PROJECTOR, read .disabled
      local flag
      flag="$(printf '%s' "$json" \
        | jq -r --arg mon "$PROJECTOR" '
            recurse(.[]?)                      # walk arrays/objects safely
            | objects
            | select(.name? == $mon)
            | .disabled // empty
          ' \
        | head -n1 || true)"
      if [[ "$flag" == "true" || "$flag" == "false" ]]; then
        printf '%s\n' "$flag"
        return 0
      fi
    fi
  fi

  # Fallback: parse plain-text block
  local block flag
  block="$(hyprctl monitors all | awk "/^Monitor $PROJECTOR \\(/,/^$/" )"
  # If block is empty, try non-ALL as a last resort
  if [[ -z "$block" ]]; then
    block="$(hyprctl monitors | awk "/^Monitor $PROJECTOR \\(/,/^$/" )"
  fi
  if [[ -z "$block" ]]; then
    echo "__not_found__"
    return 0
  fi
  flag="$(grep -m1 '^[[:space:]]*disabled:' <<<"$block" | awk '{print $2}')"
  if [[ "$flag" == "true" || "$flag" == "false" ]]; then
    printf '%s\n' "$flag"
  else
    echo "__unknown__"
  fi
}

disabled="$(read_disabled_flag)"

if [[ "$disabled" == "__not_found__" ]]; then
  echo "Monitor $PROJECTOR not found (even with 'monitors all')." >&2
  exit 1
fi

if [[ "$disabled" == "true" ]]; then
  # Projector is OFF → enable dual setup
  hyprctl keyword monitor "$PROJECTOR, 1920x1080, 960x0, 1"
  hyprctl keyword monitor "$MAIN, 3840x1600, 0x1080, 1"
  echo "Projector enabled, dual setup applied."
elif [[ "$disabled" == "false" ]]; then
  # Projector is ON → disable it and keep only main
  hyprctl keyword monitor "$PROJECTOR, disable"
  hyprctl keyword monitor "$MAIN, 3840x1600, 0x0, 1"
  echo "Projector disabled, single-monitor setup applied."
else
  echo "Could not determine projector state (got: $disabled). Check names or Hyprland output format." >&2
  exit 2
fi


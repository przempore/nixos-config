#!/usr/bin/env bash
set -euo pipefail

PROJECTOR="HDMI-A-2"
MAIN="DP-2"
PROJECTOR_MODE="${PROJECTOR_MODE:-1920x1080}"
MAIN_MODE="${MAIN_MODE:-3840x1600@144}"

# --- helper: parse WxH (optionally with @rr) into "W H" ---
parse_mode_dims() {
  local mode="$1"
  if [[ "$mode" =~ ^([0-9]+)x([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}"
  fi
}

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
      elif [[ "$flag" == "0" || "$flag" == "1" ]]; then
        [[ "$flag" == "1" ]] && echo "true" || echo "false"
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
  elif [[ "$flag" == "0" || "$flag" == "1" ]]; then
    [[ "$flag" == "1" ]] && echo "true" || echo "false"
  else
    echo "__unknown__"
  fi
}

# --- helper: find current MAIN width (for positioning math) ---
get_main_width() {
  if command -v jq >/dev/null 2>&1; then
    local json width
    json="$(hyprctl -j monitors 2>/dev/null || true)"
    if [[ -n "$json" ]]; then
      width="$(printf '%s' "$json" \
        | jq -r --arg mon "$MAIN" 'map(select(.name==$mon))[0].width // empty' \
        | head -n1)"
      if [[ "$width" =~ ^[0-9]+$ ]]; then
        printf '%s\n' "$width"
        return 0
      fi
    fi
  fi

  local block width
  block="$(hyprctl monitors | awk "/^Monitor $MAIN \\(/,/^$/" )"
  width="$(awk '/^[[:space:]]*width:/ {print $2}' <<<"$block" | head -n1)"
  if [[ "$width" =~ ^[0-9]+$ ]]; then
    printf '%s\n' "$width"
  fi
}

disabled="$(read_disabled_flag)"

if [[ "$disabled" == "__not_found__" ]]; then
  echo "Monitor $PROJECTOR not found (even with 'monitors all')." >&2
  exit 1
fi

if [[ "$disabled" == "true" ]]; then
  main_width="$(get_main_width)"
  read pmode_w pmode_h <<<"$(parse_mode_dims "$PROJECTOR_MODE")"
  read mmode_w mmode_h <<<"$(parse_mode_dims "$MAIN_MODE")"
  main_width="${main_width:-${mmode_w:-3840}}"
  pmode_w="${pmode_w:-1920}"
  pmode_h="${pmode_h:-1080}"

  # Place projector above main, horizontally centered
  offset_x=$(( main_width > pmode_w ? (main_width - pmode_w) / 2 : 0 ))
  offset_y=$(( -pmode_h ))

  # Projector is OFF → enable dual setup
  hyprctl keyword monitor "$MAIN, $MAIN_MODE, 0x0, 1"
  hyprctl keyword monitor "$PROJECTOR, $PROJECTOR_MODE, ${offset_x}x${offset_y}, 1"
  echo "Projector enabled, dual setup applied."
elif [[ "$disabled" == "false" ]]; then
  # Projector is ON → disable it and keep only main
  hyprctl keyword monitor "$PROJECTOR, disable"
  hyprctl keyword monitor "$MAIN, $MAIN_MODE, 0x0, 1"
  echo "Projector disabled, single-monitor setup applied."
else
  echo "Could not determine projector state (got: $disabled). Check names or Hyprland output format." >&2
  exit 2
fi

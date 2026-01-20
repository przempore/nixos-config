{ lib, ... }:
{
  home.file.".config/niri/config.kdl" = lib.mkForce {
    text = ''
      ${builtins.readFile ../../common/niri/config.kdl}

      output "DP-2" {
          mode "3840x1600@144"
          transform "normal"
          position x=0 y=0
      }

      output "HDMI-A-2" {
          off
          mode "1920x1080"
          transform "normal"
          // Center the projector above the main monitor (3840x1600 -> x=960, y=-1080).
          position x=960 y=-1080
      }
    '';
  };

  home.file.".config/niri/scripts/toggle_projector.sh" = {
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      output="HDMI-A-2"

      if ! json="$(niri msg -j outputs 2>/dev/null)"; then
        echo "toggle_projector: niri is not running" >&2
        exit 1
      fi

      enabled="$(
        printf '%s' "$json" |
          jq -r --arg name "$output" '
            def outinfo:
              if type == "array" then
                (map(select(.name == $name)) | .[0] // null)
              elif type == "object" then
                (.[$name] // null)
              else
                null
              end;

            (outinfo | .logical != null) // false
          '
      )"

      case "$enabled" in
        true)
          exec niri msg output "$output" off
          ;;
        false|"")
          exec niri msg output "$output" on
          ;;
        *)
          echo "toggle_projector: unexpected enabled=$enabled" >&2
          exit 2
          ;;
      esac
    '';
    executable = true;
  };
}

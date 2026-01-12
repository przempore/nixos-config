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
          mode "1920x1080"
          transform "normal"
          // Center the projector above the main monitor (3840x1600 -> x=960, y=-1080).
          position x=960 y=-1080
      }
    '';
  };
}

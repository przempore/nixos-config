{ inputs, pkgs, ... }:
let
  noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  wallpaper = ./screen_settings/wallpaper/nature_of_fear_Nicola_Samori.jpg;

  commandRunner = pkgs.writeShellApplication {
    name = "noctalia-command-runner";
    runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.bash noctaliaPackage ];
    text = ''
      set -euo pipefail

      IFS=: read -r -a path_dirs <<<"$HOME/.nix-profile/bin:$HOME/.local/state/nix/profiles/home-manager/home-path/bin:/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:$PATH"
      selected="$(
        for directory in "''${path_dirs[@]}"; do
          [ -d "$directory" ] || continue
          find -L "$directory" -maxdepth 1 -type f -executable -printf '%f\\n'
        done | sort -u | noctalia dmenu -p 'Run command'
      )" || exit 0
      [ -n "$selected" ] || exit 0
      nohup bash -lc "$selected" >/dev/null 2>&1 </dev/null &
    '';
  };
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      keybinds = {
        up = [ "up" "ctrl+p" ];
        down = [ "down" "ctrl+n" ];
      };

      shell = {
        setup_wizard_enabled = false;
        clipboard_enabled = true;
        launcher = {
          layout = "full";
          default_view = "all";
          show_icons = true;
        };
        window_switcher = {
          style = "compact";
          mru = true;
          show_all_outputs = true;
        };
        keyboard_layout.custom_labels = {
          "English (US)" = "EN";
          "English (Dvorak)" = "DV";
          "English (Programmer Dvorak)" = "DV";
          us = "EN";
          real-prog-dvorak = "DV";
        };
        screenshot = {
          save_to_file = true;
          directory = "~/Pictures/Screenshots";
          filename_pattern = "Screenshot from %Y-%m-%d %H-%M-%S";
          copy_to_clipboard = true;
          freeze_screen = true;
        };
      };

      lockscreen = {
        enabled = true;
        grace_period_seconds = 0;
      };

      notification.enable_daemon = true;

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        default.path = toString wallpaper;
      };

      backdrop.enabled = true;
      location.auto_locate = true;

      weather = {
        enabled = true;
        unit = "metric";
      };

      nightlight = {
        enabled = true;
        temperature_day = 6500;
        temperature_night = 3500;
      };

      bar.default = {
        enabled = true;
        position = "top";
        thickness = 30;
        background_opacity = 1.0;
        compositor_blur = false;
        radius = 0;
        margin_ends = 0;
        margin_edge = 0;
        padding = 10;
        widget_spacing = 8;
        start = [ "workspaces" "active_window" ];
        center = [ "weather" ];
        end = [ "keyboard_layout" "volume" "network" "memory" "cpu" "clock" "battery" "tray" ];
      };

      widget = {
        active_window.max_length = 50;
        clock = {
          format = " {:%d-%m-%Y %H:%M}";
        };
        memory = {
          type = "sysmon";
          stat = "ram_pct";
          visualization = "none";
        };
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
        };
        volume.actions = {
          left = "volume-mute";
          right = "panel-toggle control-center audio";
          scroll_up = "volume-up 2";
          scroll_down = "volume-down 2";
        };
      };
    };
  };

  home.packages = [ commandRunner ];
}

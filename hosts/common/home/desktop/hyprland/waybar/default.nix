{ pkgs, ... }:
let
  weather-plugin = pkgs.writeShellApplication {
    name = "weather-plugin";
    runtimeInputs = with pkgs; [ jq bc curl ];
    text = ''
      set +u  # Disable unbound variable check for legacy script
      ${builtins.readFile ./config/scripts/weather.sh}
    '';
    checkPhase = "";  # Skip shellcheck validation
  };

  keyboard-layout-switch = pkgs.writeShellApplication {
    name = "keyboard-layout-switch";
    runtimeInputs = with pkgs; [ jq ];
    text = builtins.readFile ./config/scripts/keyboard_layout_switch.sh;
  };
in
{
  programs.waybar = {
    enable = true;
    style = builtins.readFile ./config/style.css;

    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "custom/kernel" "custom/weather" ];
      modules-right = [ "hyprland/language" "pulseaudio" "network" "memory" "cpu" "clock" "battery" "tray" ];
      "hyprland/workspaces" = {
        format = "{name}: {icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          "6" = "";
          "7" = "";
          "8" = "";
          "9" = "";
          "10" = "";
        };
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        show-special = false;
      };
      "hyprland/window" = {
        format = "{}";
        max-length = 50;
        separate-outputs = true;
      };
      "custom/kernel" = {
        format = " {}";
        exec = "uname -r";
        interval = 1024;
        return-type = "string";
      };
      "custom/weather" = {
        format = "{}";
        exec = "${weather-plugin}/bin/weather-plugin";
        interval = 960;
        return-type = "string";
        on-click = "${weather-plugin}/bin/weather-plugin";
      };
      "hyprland/language" = {
        format = "⌨ {}";
        format-en = "EN";
        format-pl = "DV";
        on-click = "${keyboard-layout-switch}/bin/keyboard-layout-switch";
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "🔇";
        format-icons = {
          default = [ "🔈" "🔉" "🔊" ];
        };
        on-click = "~/.config/polybar/pavolume.sh --togmute";
        on-click-right = "pavucontrol";
        on-scroll-up = "~/.config/polybar/pavolume.sh --up";
        on-scroll-down = "~/.config/polybar/pavolume.sh --down";
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      memory = {
        format = "{}% ";
      };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
        interval = 5;
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = " {:%d-%m-%Y %H:%M}";
        format-alt = " {:%Y-%m-%d %H:%M}";
        interval = 5;
      };
      battery = {
        bat = "BAT0";
        interval = 30;
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [ "" "" "" "" "" ];
        tooltip = true;
        tooltip-format = "{time} remaining";
      };
      tray = {
        icon-size = 20;
        spacing = 10;
        show-passive-items = true;
      };
    }];
  };

  home.file.".config/waybar/config.niri".text = builtins.toJSON [{
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [ "niri/workspaces" "niri/window" ];
    modules-center = [ "custom/kernel" "custom/weather" ];
    modules-right = [ "pulseaudio" "network" "memory" "cpu" "clock" "battery" "tray" ];

    "niri/workspaces" = {
      format = "{index}: {icon}";
      format-icons = {
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
        "5" = "";
        "6" = "";
        "7" = "";
        "8" = "";
        "9" = "";
        "10" = "";
      };
    };
    "niri/window" = {
      format = "{}";
      max-length = 50;
      separate-outputs = true;
    };

    "custom/kernel" = {
      format = " {}";
      exec = "uname -r";
      interval = 1024;
      return-type = "string";
    };
    "custom/weather" = {
      format = "{}";
      exec = "${weather-plugin}/bin/weather-plugin";
      interval = 960;
      return-type = "string";
      on-click = "${weather-plugin}/bin/weather-plugin";
    };
    pulseaudio = {
      format = "{volume}% {icon}";
      format-muted = "🔇";
      format-icons = {
        default = [ "🔈" "🔉" "🔊" ];
      };
      on-click = "~/.config/polybar/pavolume.sh --togmute";
      on-click-right = "pavucontrol";
      on-scroll-up = "~/.config/polybar/pavolume.sh --up";
      on-scroll-down = "~/.config/polybar/pavolume.sh --down";
    };
    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ipaddr}/{cidr} ";
      tooltip-format = "{ifname} via {gwaddr} ";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{ifname}: {ipaddr}/{cidr}";
    };
    memory = {
      format = "{}% ";
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
      interval = 5;
    };
    clock = {
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format = " {:%d-%m-%Y %H:%M}";
      format-alt = " {:%Y-%m-%d %H:%M}";
      interval = 5;
    };
    battery = {
      bat = "BAT0";
      interval = 30;
      format = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = [ "" "" "" "" "" ];
      tooltip = true;
      tooltip-format = "{time} remaining";
    };
    tray = {
      icon-size = 20;
      spacing = 10;
      show-passive-items = true;
    };
  }];

  home.file.".config/waybar/scripts/start_waybar.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      set -euo pipefail

      if [ -n "''${NIRI_SOCKET:-}" ]; then
        exec waybar -c "$HOME/.config/waybar/config.niri"
      else
        exec waybar
      fi
    '';
  };

  home.file.".config/waybar/scripts/toggle_waybar.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      echo "[toggle_waybar] start" | systemd-cat

      if pgrep -x .waybar-wrapped >/dev/null; then
        echo "[toggle_waybar] stopping waybar" | systemd-cat
        pkill -x .waybar-wrapped
      else
        echo "[toggle_waybar] starting waybar" | systemd-cat
        uwsm-app -- ~/.config/waybar/scripts/start_waybar.sh
      fi

      echo "[toggle_waybar] end" | systemd-cat
    '';
  };
}

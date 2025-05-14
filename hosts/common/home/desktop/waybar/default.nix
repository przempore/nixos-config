{ pkgs, ... }:
let
  name = "weather-plugin";
  weather-plugin = (pkgs.writeScriptBin name (builtins.readFile ./config/scripts/weather.sh)).overrideAttrs (old: {
    buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });
  wrapped-weather-plugin = pkgs.symlinkJoin {
    inherit name;
    paths = [ weather-plugin ] ++ (with pkgs; [ jq bc curl ]);
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/weather-plugin --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jq pkgs.bc pkgs.curl ]}
    '';
  };
in
{
  # home.file.".config/waybar" = {
  #   source = ./config;
  #   recursive = true;
  # };

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./config/style.css;

    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = ["custom/kernel" "custom/weather"];
      # "modules-center": ["custom/kernel"],
      modules-right = ["pulseaudio" "network" "memory" "cpu" "clock" "battery" "tray"];
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
          # "default": "",
          # "active": "",
          # "default": ""
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
        exec = "${wrapped-weather-plugin}/bin/weather-plugin";
        interval = 960;
        return-type = "string";
        on-click = "${wrapped-weather-plugin}/bin/weather-plugin";
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "🔇";
        format-icons = {
          default = ["🔈" "🔉" "🔊"];
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
        format-icons = ["" "" "" "" ""];
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
}

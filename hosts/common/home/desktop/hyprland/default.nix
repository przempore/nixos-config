{ pkgs, lib, machine, ... }:
let
  wallpaper = ../screen_settings/wallpaper/nature_of_fear_Nicola_Samori.jpg;
  hyprpaperMonitor = if machine == "ilum" then "DP-2" else "eDP-1";

  ilumPart = ''
    monitor=DP-2,3840x1600@144,0x0,1
    monitor=HDMI-A-1,disable
    monitor=HDMI-A-2,disable

    env = NVD_BACKEND,direct
    env = LIBVA_DRIVER_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = WLR_NO_HARDWARE_CURSORS,1
    env = WLR_RENDERER,vulkan
  '';
  dookuPart = ''
    monitor=,preferred,auto,1

    device {
      name        = at-translated-set-2-keyboard
      kb_layout   = real-prog-dvorak,us
      kb_options  = ctrl:swapcaps,altwin:swap_lalt_lwin
    }
  '';
  commonPart = ''
    ${if machine == "ilum" then ilumPart else if machine == "dooku" then dookuPart else ""}
    ${builtins.readFile ./config/common_hyprland.conf}
  '';
in
{
  imports = [
    ./dunst.nix
    ./waybar
    ./wlsunset.nix
  ];

  home.file.".config/hypr" = {
    source = ./config;
    recursive = true;
  };

  home.file.".config/hypr/hyprland.conf".text = lib.strings.trim commonPart;
  home.file.".config/hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor = ${hyprpaperMonitor}
      path = ${wallpaper}
    }
  '';

  home.packages = with pkgs; [
    wofi
    grim
    slurp
    swappy
  ];
}

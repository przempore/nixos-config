{ pkgs, lib, machine, ... }:
let
  ilumPart = ''
    monitor= HDMI-A-2, disable

    env = NVD_BACKEND,direct
    env = LIBVA_DRIVER_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = WLR_NO_HARDWARE_CURSORS,1
    env = WLR_RENDERER,vulkan
  '';
  commonPart = ''
    ${if machine == "ilum" then ilumPart else ""}
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

  home.packages = with pkgs; [
    wofi
  ];
}

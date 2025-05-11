{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./hyprland
    ./waybar
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
    ./gtk.nix
  ];
}


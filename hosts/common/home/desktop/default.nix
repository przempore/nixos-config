{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./gtk.nix
    ./hyprland
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
    ./waybar
  ];
}


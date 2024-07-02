{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
    ./gtk.nix
  ];
}


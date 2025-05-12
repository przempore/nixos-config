{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./gtk.nix
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
  ];
}


{ config, pkgs, pkgs-unstable, allowed-unfree-packages, ... }:
{
  imports = [
    ./bspwm
    ./picom.nix
    ./polybar
    ./screen_settings
  ];
}

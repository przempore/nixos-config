{ config, pkgs, ... }:
{
  imports = [
    ./bspwm
    ./picom.nix
    ./polybar
    ./screen_settings
    ./sxhkd.nix
  ];

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      accent = "pink";
      flavor = "macchiato";
      tweaks = [ "rimless" ];
      icon = {
        enable = true;
        accent = "pink";
        flavor = "macchiato";
      };
    };
  };
}


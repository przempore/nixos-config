{ pkgs, ... }:
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

  home.packages = with pkgs; [
    wofi
  ];
}

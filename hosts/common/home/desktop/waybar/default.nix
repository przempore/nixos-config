{ pkgs, ... }:
{
  home.file.".config/waybar" = {
    source = ./config;
    recursive = true;
  };

  home.packages = with pkgs; [
    wofi
  ];
}

{ pkgs, ... }:
{
  home.file.".config/niri/config.kdl".source = ./config.kdl;

  home.packages = with pkgs; [
    swaybg
  ];
}

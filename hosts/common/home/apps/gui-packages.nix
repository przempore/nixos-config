{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    wireguard-tools
    obsidian
    signal-desktop
    zathura
    spotify
    keepassxc
    onlyoffice-desktopeditors
    pkgs-unstable.discord
  ];

}

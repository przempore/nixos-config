{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wireguard-tools
    obsidian
    signal-desktop
    zathura
    spotify
    keepassxc
    brave
    onlyoffice-bin_latest
  ];

}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wireguard-tools
    obsidian
    signal-desktop
    zathura
    spotify
    keepassxc
    onlyoffice-desktopeditors
  ];

}

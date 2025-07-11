{ pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs; [
    autojump
    eza
    fzf
    fd
    ripgrep
    fastfetch
    yazi
    sshfs
    ncpamixer
    lazydocker

    wireguard-tools

    obsidian
    distrobox
    signal-desktop
    zathura

    spotify
    keepassxc
    brave
    onlyoffice-bin_latest
  ];

}

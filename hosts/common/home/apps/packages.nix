{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autojump
    fzf
    fd
    ripgrep
    fastfetch
    yazi
    sshfs
    ncpamixer
    lazydocker
    distrobox
  ];

}

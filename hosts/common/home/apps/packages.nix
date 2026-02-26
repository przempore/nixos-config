{ pkgs, lib, ... }:
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
    spotify-player
  ];

  programs.autojump = {
    enable = lib.mkDefault true;
    enableZshIntegration = true;
  };


}

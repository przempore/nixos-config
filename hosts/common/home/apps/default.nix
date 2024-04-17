{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    any-nix-shell
    autojump
    eza
    fzf # A command-line fuzzy finder
    lf
    neofetch
    nnn # terminal file manager
    ripgrep
    sshfs
  ];

  imports = [
    ./firefox.nix
    ./fish.nix
    ./git.nix
    ./kitty
    ./mpv.nix
    ./nvim
    ./ranger.nix
    ./sxhkd.nix
    ./tmux.nix
    ./wezterm
    ./zathura.nix
  ];
}

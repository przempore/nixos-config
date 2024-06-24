{ pkgs, ... }:
{
  home.packages = with pkgs; [
    any-nix-shell
    autojump
    eza
    fzf # A command-line fuzzy finder
    ripgrep
    fastfetch
    yazi
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
    ./tmux.nix
    ./wezterm
    ./zathura.nix
  ];
}

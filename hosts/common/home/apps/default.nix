{ config, pkgs, ... }:
{
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

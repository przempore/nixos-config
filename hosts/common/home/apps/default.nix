{ pkgs, pkgs-unstable, ... }:
{
  imports = [
    ./direnv.nix
    # ./firefox.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./kitty
    ./mpv.nix
    ./nvim
    ./packages.nix
    ./ranger.nix
    ./starship.nix
    ./superfile.nix
    ./tmux.nix
    ./wezterm
    ./zathura.nix
    ./zen
  ];
}

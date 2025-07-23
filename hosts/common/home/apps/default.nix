{ lib, isWSL ? false, ... }:
{
  imports = [
    # ./firefox.nix
    ./direnv.nix
    ./fish.nix
    ./zsh.nix
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
  ] ++ lib.optionals (!isWSL) [
    ./gui-packages.nix
  ];
}

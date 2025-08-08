{ lib, isWSL ? false, enableGhostty ? true, ... }:
{
  imports = [
    # ./firefox.nix
    ./direnv.nix
    ./fish.nix
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
    ./zsh.nix
  ] ++ lib.optionals (!isWSL) [
    ./gui-packages.nix
  ] ++ lib.optionals enableGhostty [
    ./ghostty.nix
  ];
}

{ lib, isWSL ? false, enableGhostty ? true, enableGui ? true, ... }:
{
  imports = [
    # ./firefox.nix
    ./direnv.nix
    ./fish.nix
    ./git.nix
    ./herdr.nix
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
  ] ++ lib.optionals enableGui [
    ./gui-packages.nix
  ] ++ lib.optionals enableGhostty [
    ./ghostty.nix
  ];
}

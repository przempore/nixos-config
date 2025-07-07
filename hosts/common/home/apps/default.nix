{ pkgs, pkgs-unstable, ... }:
{
  home.packages = [
  ]
  ++ (with pkgs; [
    autojump
    eza
    fzf # A command-line fuzzy finder
    fd
    ripgrep
    fastfetch
    yazi
    sshfs
    # discord
    ncpamixer
    lazydocker

    wireguard-tools
  ])
  ++ (with pkgs-unstable; [
    superfile
  ]);

  imports = [
    ./direnv.nix
    # ./firefox.nix
    ./fish.nix
    ./ghostty.nix
    ./git.nix
    ./kitty
    ./mpv.nix
    ./nvim
    ./ranger.nix
    ./starship.nix
    ./superfile.nix
    ./tmux.nix
    ./wezterm
    ./zathura.nix
    ./zen
  ];
}

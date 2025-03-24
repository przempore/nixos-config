{ pkgs, pkgs-unstable, zen-browser, ghostty, ... }:
{
  home.packages = [
    zen-browser.packages.x86_64-linux.beta
    ghostty.packages.x86_64-linux.default
  ]
  ++ (with pkgs; [
    any-nix-shell
    autojump
    eza
    fzf # A command-line fuzzy finder
    ripgrep
    fastfetch
    yazi
    sshfs
    discord
    ncpamixer
    lazydocker

    wireguard-tools
  ])
  ++ (with pkgs-unstable; [
    superfile
  ]);

  imports = [
    ./direnv.nix
    ./firefox.nix
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
  ];
}

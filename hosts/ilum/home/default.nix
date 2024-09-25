{ pkgs, lib, allowed-unfree-packages, permittedInsecurePackages, zen-browser, ... }:
{
  imports = [
    ./kitty.nix # kitty configuration without kitty package

    ../../common/home/catppuccin.nix

    ../../common/home/apps/direnv.nix
    ../../common/home/apps/firefox.nix
    ../../common/home/apps/fish.nix
    ../../common/home/apps/git.nix
    # ../../common/home/apps/kitty # kitty installed via nixpkgs
    ../../common/home/apps/mpv.nix
    ../../common/home/apps/nvim
    ../../common/home/apps/ranger.nix
    ../../common/home/apps/starship.nix
    ../../common/home/apps/tmux.nix
    ../../common/home/apps/zathura.nix


    ../../common/home/desktop/polybar
    ../../common/home/desktop/sxhkd.nix
  ];

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";

    packages = with pkgs; [
      autojump
      eza
      fzf # A command-line fuzzy finder
      ripgrep
      fastfetch
      yazi
      sshfs
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  nixpkgs.config.permittedInsecurePackages = permittedInsecurePackages; # here for home-manager

  catppuccin = {
    enable = false;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs = {
    fish = {
      catppuccin.enable = true;
      shellAliases = {
        asdf = "setxkbmap -layout pl -variant real-prog-dvorak && xset r rate 200 25";
        aoeu = "setxkbmap -layout pl && xset r rate 200 25";
      };

      interactiveShellInit = ''
        set -gx PATH $PATH $HOME/.cargo/bin $HOME/.local/bin $HOME/go/bin
      '';
    };

    neovim = {
      catppuccin.enable = true;
    };

    home-manager.enable = true;
  };
}

{ lib, allowed-unfree-packages, permittedInsecurePackages, pkgs-unstable, ... }:
{
  imports = [
    ../../common/home/apps
    ../../common/home/catppuccin.nix
  ];

  # Packages that should be installed to the user profile.
  home = {
    username = "przemek";
    homeDirectory = "/home/przemek";
    programs = [
      pkgs-unstable.direnv
    ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed-unfree-packages;
  nixpkgs.config.permittedInsecurePackages = permittedInsecurePackages; # here for home-manager

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
      shellAliases = {
        asdf = "$HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=dvorak";
        aoeu = "$HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=qwerty";
      };
 
      interactiveShellInit = ''
        set -gx PATH $PATH $HOME/.cargo/bin $HOME/.local/bin $HOME/go/bin
      '';
    };

    home-manager.enable = true;
  };
}

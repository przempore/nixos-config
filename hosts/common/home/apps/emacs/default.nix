{ inputs, pkgs, pkgs-unstable, ... }:
{
  home.sessionVariables = {
    EMACSDIR = "$HOME/.config/emacs";
    DOOMDIR = "$HOME/.config/doom";
    DOOMLOCALDIR = "$HOME/.cache/doom";
  };

  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];

  programs.emacs = {
    enable = true;
    package = pkgs-unstable.emacs-pgtk;
  };

  home.file = {
    ".config/emacs".source = inputs.doom-emacs;
    ".config/doom" = {
      source = inputs.doom-config;
      recursive = true;
    };
  };
}

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

  services.emacs = {
    enable = true;
    package = pkgs-unstable.emacs-pgtk;
  };

  systemd.user.services.emacs.Service.Environment = [
    "DOOMLOCALDIR=%h/.cache/doom"
    "EMACS_TREESIT_GRAMMAR_PATH=${treesitGrammarPath}"
  ];

  home.file = {
    ".config/emacs".source = inputs.doom-emacs;
    ".config/doom" = {
      source = inputs.doom-config;
      recursive = true;
    };
  };
}

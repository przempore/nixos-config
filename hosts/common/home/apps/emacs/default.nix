{ inputs, lib, pkgs, pkgs-unstable, ... }:
let
  grammars = {
    bash = pkgs-unstable.tree-sitter-grammars.tree-sitter-bash;
    c = pkgs-unstable.tree-sitter-grammars.tree-sitter-c;
    cmake = pkgs-unstable.tree-sitter-grammars.tree-sitter-cmake;
    cpp = pkgs-unstable.tree-sitter-grammars.tree-sitter-cpp;
    just = pkgs-unstable.tree-sitter-grammars.tree-sitter-just;
    json = pkgs-unstable.tree-sitter-grammars.tree-sitter-json;
    lua = pkgs-unstable.tree-sitter-grammars.tree-sitter-lua;
    make = pkgs-unstable.tree-sitter-grammars.tree-sitter-make;
    markdown = pkgs-unstable.tree-sitter-grammars.tree-sitter-markdown;
    markdown-inline = pkgs-unstable.tree-sitter-grammars.tree-sitter-markdown-inline;
    nim = pkgs-unstable.tree-sitter-grammars.tree-sitter-nim;
    nix = pkgs-unstable.tree-sitter-grammars.tree-sitter-nix;
    python = pkgs-unstable.tree-sitter-grammars.tree-sitter-python;
    rust = pkgs-unstable.tree-sitter-grammars.tree-sitter-rust;
    toml = pkgs-unstable.tree-sitter-grammars.tree-sitter-toml;
    yaml = pkgs-unstable.tree-sitter-grammars.tree-sitter-yaml;
  };

  treesitGrammarPath = pkgs-unstable.runCommand "emacs-tree-sitter-grammars" { } ''
    mkdir -p "$out"
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (language: grammar: ''
      ln -s "${grammar}/parser" "$out/libtree-sitter-${language}.so"
    '') grammars)}
  '';
in
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

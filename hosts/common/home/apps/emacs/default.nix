{ config, inputs, lib, pkgs, pkgs-unstable, ... }:
let
  # Patch a Nix-store copy; the shared Doom config remains usable unchanged on Windows.
  # Unstraightened needs an explicit URL for GitLab recipes.
  nixosDoomConfig = pkgs.runCommand "doom-config-with-nix-pins" { } ''
    mkdir -p "$out"
    cp -R "${inputs.doom-config}/." "$out/"
    chmod -R u+w "$out"
    # Nixpkgs Ghostel exposes ghostel-mode-map; Windows uses a newer map name.
    substituteInPlace "$out/config.el" \
      --replace-fail ':map ghostel-semi-char-mode-map' \
      ':map ghostel-mode-map'
    substituteInPlace "$out/packages.el" \
      --replace-fail '(package! claudemacs' \
      '(package! claudemacs :pin "354ba3537401b4dc35012b46d24d70028ff9c197"'
    substituteInPlace "$out/packages.el" \
      --replace-fail '(package! emacs-opencode' \
      '(package! emacs-opencode :pin "8022628a62958d53e0d792ad8f20082cdc522dbf"'
    substituteInPlace "$out/packages.el" \
      --replace-fail '(package! modus-catppuccin' \
      '(package! modus-catppuccin :pin "a0f7bd9e258b717f9c2b398fae1085d50615c5d2"'
    substituteInPlace "$out/packages.el" \
      --replace-fail '(package! window-stool' \
      '(package! window-stool :pin "deb8200f7a6bcfb3a317c62f637e56d2c5af7263"'
    substituteInPlace "$out/packages.el" \
      --replace-fail ':host gitlab' ':host nil' \
      --replace-fail ':repo "magus/modus-catppuccin"' \
      ':repo "https://gitlab.com/magus/modus-catppuccin.git"'
  '';
  unstableEmacsPackages = pkgs-unstable.emacsPackagesFor pkgs-unstable.emacs-pgtk;
in
{
  imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

  programs.doom-emacs = {
    enable = true;
    emacs = pkgs-unstable.emacs-pgtk;
    doomDir = nixosDoomConfig;
    doomLocalDir = "${config.home.homeDirectory}/.cache/doom";
    # These packages use dependencies absent from their package headers.
    emacsPackageOverrides = eself: esuper: {
      # Doom's :term ghostel +everywhere module uses ghostel-comint-mode,
      # which is missing from the older Ghostel in the stable package set.
      ghostel = unstableEmacsPackages.ghostel;
      claudemacs = esuper.claudemacs.overrideAttrs (old: {
        packageRequires = lib.unique (
          (old.packageRequires or [ ]) ++ [
            esuper.eat
            eself.ghostel
          ]
        );
      });
      emacs-opencode = esuper.emacs-opencode.overrideAttrs (old: {
        packageRequires = lib.unique (
          (old.packageRequires or [ ]) ++ [ esuper.request ]
        );
      });
      evil-ghostel = unstableEmacsPackages.evil-ghostel;
    };
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.nixfmt
      (epkgs.treesit-grammars.with-grammars (grammars: with grammars; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-cmake
        tree-sitter-cpp
        tree-sitter-just
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-make
        tree-sitter-markdown
        tree-sitter-markdown-inline
        tree-sitter-nim
        tree-sitter-nix
        tree-sitter-python
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-yaml
      ]))
    ];
  };

  home.packages = [
    pkgs.stdenv.cc
    pkgs-unstable.nodejs
    (pkgs.aspellWithDicts (dicts: [
        dicts.en
        dicts.en-computers
        dicts.de
        dicts.pl
    ]))
  ];

  services.emacs = {
    enable = true;
  };

  systemd.user.services.emacs.Service.Environment = [
    "PATH=${lib.makeBinPath [ pkgs-unstable.nodejs pkgs-unstable.opencode ]}:${config.home.profileDirectory}/bin:/run/wrappers/bin:/run/current-system/sw/bin"
  ];

  home.activation.createDoomProfileStateDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg "${config.home.homeDirectory}/.local/state/doom/nix"} $VERBOSE_ARG
  '';
}

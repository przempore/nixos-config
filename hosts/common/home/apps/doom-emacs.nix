{ inputs, pkgs, ... }:
{
  home.sessionPath = [
    "$HOME/.config/emacs/bin"
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  home.file = {
    ".config/emacs".source = inputs.doom-emacs;

    ".config/doom/init.el".text = ''
      ;;; $DOOMDIR/init.el -*- lexical-binding: t; -*-

      (doom! :completion
             (corfu +orderless)
             vertico

             :ui
             doom
             dashboard
             hl-todo
             modeline
             ophints
             (popup +defaults)
             (vc-gutter +pretty)
             vi-tilde-fringe
             workspaces

             :editor
             (evil +everywhere)
             file-templates
             fold
             (format +onsave)
             snippets
             (whitespace +guess +trim)

             :emacs
             dired
             electric
             tramp
             undo
             vc

             :checkers
             syntax

             :tools
             (eval +overlay)
             lookup
             (lsp +eglot)
             magit
             tree-sitter

             :lang
             (cc +lsp)
             emacs-lisp
             json
             lua
             markdown
             nim
             nix
             org
             (python +lsp)
             qt
             (rust +lsp)
             sh

             :app
             calendar

             :config
             (default +bindings +smartparens))
    '';

    ".config/doom/config.el".text = ''
      ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

      (setq doom-theme 'catppuccin-mocha
            display-line-numbers-type 'relative
            org-directory "~/org/")

      ;; Switch between headers and sources in C and C++ buffers.
      (map! :after cc-mode
            :map (c-mode-map c++-mode-map)
            "<f10>" #'ff-find-other-file)
      (map! :after c-ts-mode
            :map (c-ts-mode-map c++-ts-mode-map)
            "<f10>" #'ff-find-other-file)

      (use-package! claudemacs
        :config
        (setq claudemacs-terminal-backend 'ghostel)
        (map! :leader
              "c a" nil
              (:prefix ("c a" . "actions")
               :desc "Code actions" "a" #'eglot-code-actions
               :desc "Claude" "c" #'claudemacs-transient-menu)))

      (use-package! ghostel
        :bind (("C-x m" . ghostel)
               :map ghostel-semi-char-mode-map
               ("C-s" . consult-line)
               :map project-prefix-map
               ("m" . ghostel-project)
               ("M" . ghostel-project-list-buffers))
        :config
        (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
        (add-to-list 'project-switch-commands
                     '(ghostel-project-list-buffers "Ghostel buffers") t)
        (add-to-list 'ghostel-eval-cmds
                     '("magit-status-setup-buffer" magit-status-setup-buffer)))

      (use-package! evil-ghostel
        :after (ghostel evil)
        :hook (ghostel-mode . evil-ghostel-mode))

      (use-package! ghostel-comint
        :hook (after-init . ghostel-comint-global-mode))

      (use-package! ghostel-org
        :after org)

      (use-package! drag-stuff
        :config
        (drag-stuff-global-mode 1)
        (map! :v
              "J" #'drag-stuff-down
              "K" #'drag-stuff-up))
    '';

    ".config/doom/packages.el".text = ''
      ;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t; -*-

      (package! claudemacs
        :recipe (:host github
                 :repo "cpoile/claudemacs"
                 :files ("*.el")))

      (package! ghostel
        :recipe (:host github :repo "dakra/ghostel"))

      (package! evil-ghostel
        :recipe (:host github :repo "dakra/ghostel"
                 :files ("extensions/evil-ghostel/evil-ghostel.el")))

      (package! drag-stuff)

      (package! modus-catppuccin
        :recipe (:host gitlab
                 :repo "magus/modus-catppuccin"))
    '';
  };
}

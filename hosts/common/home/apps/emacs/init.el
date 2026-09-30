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

       :term
       (ghostel +everywhere)

       :checkers
       syntax

       :tools
       direnv
       (eval +overlay)
       lookup
       (lsp +eglot)
       magit
       tree-sitter

       :lang
       (cc +lsp +tree-sitter)
       emacs-lisp
       json
       lua
       markdown
       nim
       (nix +lsp +tree-sitter)
       org
       (python +lsp +tree-sitter)
       qt
       (rust +lsp +tree-sitter)
       sh

       :app
       calendar

       :config
       (default +bindings +smartparens))

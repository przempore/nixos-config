;;; $DOOMDIR/packages.el -*- lexical-binding: t; no-byte-compile: t; -*-

(package! claudemacs
  :recipe (:host github
           :repo "cpoile/claudemacs"
           :files ("*.el")))

(package! drag-stuff)

(package! modus-catppuccin
  :recipe (:host gitlab
           :repo "magus/modus-catppuccin"))

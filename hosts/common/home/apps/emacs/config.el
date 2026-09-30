;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "JetBrainsMono NFM" :size 14))

(setq doom-theme 'catppuccin-mocha
      display-line-numbers-type 'relative
      org-directory "~/Projects/second-brain/org/")

(after! org
  (load! "second-brain"))

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
  :bind (("C-x m" . ghostel-project)
         ("C-x M" . ghostel-list-buffers)
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
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package! ghostel-org
  :after org)

(use-package! drag-stuff
  :config
  (drag-stuff-global-mode 1)
  (map! :v
        "J" #'drag-stuff-down
        "K" #'drag-stuff-up))

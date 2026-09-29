;;; second-brain.el --- Personal Org workspace -*- lexical-binding: t; -*-

(require 'org)
(require 'org-agenda)
(require 'org-capture)
(require 'calendar)
(require 'face-remap)

(defvar-local second-brain-face-remaps nil
  "Face remapping cookies for Org typography.")

(defun second-brain-org-appearance ()
  "Give Org notes a clearer heading hierarchy while keeping theme colors."
  (mapc #'face-remap-remove-relative second-brain-face-remaps)
  (setq second-brain-face-remaps nil)
  (dolist (heading '((org-document-title . 1.8)
                     (org-level-1 . 1.5)
                     (org-level-2 . 1.3)
                     (org-level-3 . 1.15)
                     (org-level-4 . 1.05)))
    (push (face-remap-add-relative (car heading)
                                  :height (cdr heading) :weight 'bold)
          second-brain-face-remaps))
  (setq-local line-spacing 0.15
              org-hide-emphasis-markers t
              org-pretty-entities t)
  (display-line-numbers-mode -1)
  (visual-line-mode 1)
  (font-lock-flush))

(add-hook 'org-mode-hook #'second-brain-org-appearance)
;; Apply immediately to open notes too when reloading this file.
(dolist (buffer (buffer-list))
  (with-current-buffer buffer
    (when (derived-mode-p 'org-mode)
      (second-brain-org-appearance))))

(setq org-directory (expand-file-name "~/Projects/second-brain/org/")
      org-default-notes-file (expand-file-name "inbox.org" org-directory)
      org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
      org-log-done 'time
      org-log-into-drawer t
      org-agenda-start-on-weekday 1
      calendar-week-start-day 1
      org-agenda-span 'week
      org-refile-targets '((org-agenda-files :maxlevel . 3))
      org-outline-path-complete-in-steps nil
      org-refile-use-outline-path 'file)

(defun second-brain-refresh-agenda (&rest _)
  "Include existing Org files, including nested daily notes, without creating any."
  (setq org-agenda-files
        (when (file-directory-p org-directory)
          (directory-files org-directory t "\\`[^.].*\\.org\\'")))
  (dolist (directory '("Timestamps" "projects" "notes"))
    (let ((path (expand-file-name directory org-directory)))
      (when (file-directory-p path)
        (setq org-agenda-files
              (append org-agenda-files (directory-files-recursively path "\\`[^.].*\\.org\\'")))))))

(advice-add 'org-agenda :before #'second-brain-refresh-agenda)
(second-brain-refresh-agenda)

(defun second-brain-daily-path (date)
  "Return the daily note path for ISO DATE, using Obsidian's naming convention."
  (let ((system-time-locale "C"))
    (expand-file-name
     (format-time-string "Timestamps/%Y/%m-%B/%Y-%m-%d-%A.org"
                         (org-read-date nil t date))
     org-directory)))

(defun second-brain-daily (&optional date)
  "Open today's note; with a prefix argument, prompt for DATE. Create only on request."
  (interactive (list (when current-prefix-arg (org-read-date nil nil nil "Daily note date: "))))
  (let* ((date (or date (format-time-string "%Y-%m-%d")))
         (time (org-read-date nil t date))
         (system-time-locale "C")
         (path (second-brain-daily-path date)))
    (make-directory (file-name-directory path) t)
    (find-file path)
    (when (and (= (buffer-size) 0) (not (file-exists-p path)))
      (insert
       (format "#+title: %s\n#+date: %s\n#+created: %s\n#+filetags: :daily-notes:\n\n"
               (format-time-string "%A, %B %d, %Y" time) date
               (format-time-string "[%Y-%m-%d %a %H:%M]"))
       (format "<< [[daily:%s][Yesterday]] | [[daily:%s][Tomorrow]] >>\n\n"
               (org-read-date nil nil "--1d" nil time)
               (org-read-date nil nil "++1d" nil time))
       "* 📅 Daily Questions\n** 🌜 Last night, after work, I...\n- \n\n"
       "** 🙌 One thing I'm excited about right now is...\n- \n\n"
       "** 🚀 One+ thing I plan to accomplish today is...\n- [ ] \n\n"
       "** 👎 One thing I'm struggling with today is...\n- \n\n"
       "* 📝 Notes\n** 🔹 Daily Thoughts\n- \n\n"
       (format "* Notes created today\n#+BEGIN: second-brain-activity :date \"%s\" :kind created\n#+END:\n\n" date)
       (format "* Notes last touched today\n#+BEGIN: second-brain-activity :date \"%s\" :kind modified\n#+END:\n" date))
      (save-buffer)
      (goto-char (point-min))
      (search-forward "Daily Thoughts\n- "))
    (second-brain-refresh-agenda)))

(org-link-set-parameters "daily" :follow (lambda (date _) (second-brain-daily date)))

(defun org-dblock-write:second-brain-activity (params)
  "List Org notes by explicit CREATED metadata or filesystem modification date."
  (let ((date (plist-get params :date))
        (created (eq (plist-get params :kind) 'created)))
    (dolist (file (directory-files-recursively org-directory "\\`[^.].*\\.org\\'"))
      (when (if created
                (with-temp-buffer
                  (insert-file-contents file)
                  (let ((case-fold-search t))
                    (re-search-forward
                     (concat "^#\\+created: .*" (regexp-quote date)) nil t)))
              (equal date (format-time-string
                           "%Y-%m-%d" (file-attribute-modification-time (file-attributes file)))))
        (insert (format "- [[file:%s][%s]]\n"
                        (file-relative-name file default-directory)
                        (file-name-base file)))))))

(setq org-capture-templates
      `(("t" "Task" entry (file+headline ,(expand-file-name "inbox.org" org-directory) "Tasks")
         "* TODO %?\nCREATED: %U\n%a\n")
        ("n" "Note" entry (file+headline ,(expand-file-name "notes.org" org-directory) "Notes")
         "* %?\nCREATED: %U\n%a\n")
        ("e" "Calendar event" entry (file+headline ,(expand-file-name "calendar.org" org-directory) "Events")
         "* %?\n%^T\n")))

(setq org-agenda-custom-commands
      '(("b" "Second brain: week and tasks"
         ((agenda "")
          (todo "NEXT" ((org-agenda-overriding-header "Next actions")))
          (todo "TODO" ((org-agenda-overriding-header "Tasks to plan")))
          (todo "WAIT" ((org-agenda-overriding-header "Waiting for")))))))

(defun second-brain-agenda ()
  "Open the weekly planning dashboard."
  (interactive)
  (org-agenda nil "b"))

(defun second-brain-home ()
  "Open the workspace guide."
  (interactive)
  (find-file (expand-file-name "README.org" org-directory)))

;; Also works when loaded in ordinary Emacs during initial setup.
(when (fboundp 'map!)
  (eval '(map! :leader
               (:prefix ("n b" . "second brain")
                :desc "Daily note (prefix: choose date)" "d" #'second-brain-daily
                :desc "Week and tasks" "a" #'second-brain-agenda
                :desc "Capture task, note or event" "c" #'org-capture
                :desc "Calendar" "k" #'calendar
                :desc "Workspace guide" "h" #'second-brain-home))))

(provide 'second-brain)

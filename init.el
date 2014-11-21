;; Set up Cask

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)

;; Appearance

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(setq default-frame-alist '((fullscreen . maximized)))

(add-to-list 'default-frame-alist '(font . "Source Code Pro-18"))
(load-theme 'solarized-dark t)

(global-hl-line-mode)

;; Behavior

(evil-mode 1)

(ido-mode t)

;; Path

;; This seems necessary under Cygwin
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/bin")
(add-to-list 'exec-path "/usr/sbin")

;; Keep backups in one directory

(setq backup-directory-alist
      `((".*" . ,(file-name-as-directory
		  (expand-file-name "backups"
				    user-emacs-directory)))))
(setq auto-save-file-name-transforms
      `((".*" ,(file-name-as-directory
		(expand-file-name "autosave"
				  user-emacs-directory))
	 t)))

;; Remember cursor position accross sessions

(require 'saveplace)
(setq save-place-file (expand-file-name "save-place" user-emacs-directory))
(setq-default save-place t)

;; Org Mode

(require 'org)

(setq org-directory "~/Documents/org")

(setq org-log-into-drawer t)

;; Clean outlines

(setq org-startup-indented t)
(setq org-hide-leading-stars t)

;; Create new nodes

(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      `((" " "Inbox entry" entry
	 (file ,(expand-file-name "inbox.org" org-directory))
	 "* %?
:PROPERTIES:
:CREATED: %U
:END:")))

;; org-expiry

(require 'org-expiry)

;; Also insert CREATED timestamps when creating nodes manually

(setq org-expiry-inactive-timestamp t)
(org-expiry-insinuate)

;; Agenda

(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-agenda-files
      (mapcar (lambda (f)
		(expand-file-name f org-directory))
	      '("inbox.org"
		"todo.org"
		"scratch.org")))

(setq org-agenda-span 'day)

;; Refile

(setq org-refile-targets
      '((org-agenda-files . (:maxlevel . 14))))
(setq org-completion-use-ido t)
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

;; MobileOrg

(setq org-mobile-inbox-for-pull "~/Documents/org/inbox.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

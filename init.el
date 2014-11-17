;; Set up Cask

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)

;; Appearance

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(setq default-frame-alist '((fullscreen . maximized)))

(add-to-list 'default-frame-alist '(font . "Source Code Pro-24"))
(load-theme 'solarized-dark t)

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

(setq backup-directory-alist `((".*" . ,(expand-file-name "backups" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "autosave" user-emacs-directory) t)))

;; Remember cursor position accross sessions

(require 'saveplace)
(setq save-place-file (expand-file-name "save-place" user-emacs-directory))
(setq-default save-place t)

;; Org Mode

(require 'org)

(setq org-directory "~/Documents/org")

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

(setq org-agenda-files
      '("inbox.org"
	"todo.org"
	"scratch.org"))

;; Refile

(setq org-refile-targets
      '((org-agenda-files . (:maxlevel . 14))))
(setq org-completion-use-ido t)
(setq org-refile-use-outline-path 'file)

;; MobileOrg

(setq org-mobile-inbox-for-pull "~/Documents/org/inbox.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

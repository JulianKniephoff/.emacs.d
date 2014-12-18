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

;; Highlighting whitespace

(require 'whitespace)

(setq whitespace-style
      '(face trailing empty tab-mark))
(global-whitespace-mode)

;; 80 columns

(define-globalized-minor-mode global-fci-mode
  fci-mode
  (lambda ()
    (fci-mode 1)))
(global-fci-mode)

;; Behavior

(ido-mode t)

;; Evil

(evil-mode)
(global-evil-surround-mode)

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

;; Links

(global-set-key (kbd "C-c l") 'org-store-link)
(require 'org-id)
(setq org-id-link-to-org-use-id t)

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

(setq org-expiry-inactive-timestamps t)
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
(setq org-extend-today-until 4)

(require 'org-habit)
(setq org-habit-show-habits-only-for-today nil)

;; Sorting

(add-to-list 'org-agenda-sorting-strategy
	     '(agenda . (scheduled-up habit-down deadline-up)))

;; Autofocus

(defun jk/org-cmp-tsia (a b)
  (let* ((ma (or (get-text-property 1 'org-marker a)
		 (get-text-property 1 'org-hd-marker a)))
	 (mb (or (get-text-property 1 'org-marker b)
		 (get-text-property 1 'org-hd-marker b)))
	 (tsa (org-entry-get ma "TIMESTAMP_IA"))
	 (tsb (org-entry-get mb "TIMESTAMP_IA"))
	 (ta (when tsa (date-to-time tsa)))
	 (tb (when tsb (date-to-time tsb))))
    (cond ((not ta) +1)
	  ((not tb) -1)
	  ((time-less-p ta tb) -1)
	  ((time-less-p tb ta) +1)
	  (t nil))))

(setq org-agenda-custom-commands
      '(("x" "Autofocus" tags "/-DONE-CANCELED"
	 ((org-agenda-overriding-header "Autofocus")
	  (org-agenda-cmp-user-defined 'jk/org-cmp-tsia)
	  (org-agenda-sorting-strategy '(user-defined-up))))))

;; Refile

(setq org-refile-targets
      '((org-agenda-files . (:maxlevel . 14))))
(setq org-completion-use-ido t)
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

;; MobileOrg

(setq org-mobile-inbox-for-pull "~/Documents/org/inbox.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

;; Programming

;; Lisp

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

;; JavaScript

(add-hook 'js-mode-hook
          (lambda ()
            (setq indent-tabs-mode t
                  c-basic-offset 4
                  tab-width 4)))


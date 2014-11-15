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

;; Keep backups in one directory

(setq backup-directory-alist `((".*" . ,(expand-file-name "backups" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "autosave" user-emacs-directory) t)))

;; Misc

;; Path

;; This seems necessary under Cygwin

(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/bin")
(add-to-list 'exec-path "/usr/sbin")

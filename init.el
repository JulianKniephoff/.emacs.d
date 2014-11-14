;; Set up Cask

(require 'cask "~/.cask/cask.el")
(cask-initialize)

(require 'pallet)
(pallet-mode t)

;; Misc

(setq inhibit-startup-screen t)

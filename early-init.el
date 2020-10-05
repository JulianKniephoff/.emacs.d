;; Some performance optimizations
(setq previous-file-name-handler-alist file-name-handler-alist
      gc-cons-threshold 100000000  ; TODO Do you want to reset this as well?
      file-name-handler-alist nil)

(defvar jk/cask-path "/usr/share/cask/cask.el"
  "The path where Cask is installed.")

;; Load site specific stuff, e.g. values for the variables above
(load (expand-file-name "site" user-emacs-directory) 'noerror)

(require 'cask jk/cask-path)
;; TODO I don't like that this suppresses the warning for every one else
;;   but there doesn't seem to be a way to do it temporarily.
(setq warning-suppress-log-types '((package reinitialization)))
(cask-initialize)

;; Cask already called this for us ... twice ...
;; No need to call it again; startup is slow enough as it is.
(setq package-enable-at-startup nil)

;(pallet-mode)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Hide the toolbar; there are multiple ways to do this,
;; of which we currently use the cheapest but least flexible.
;; This only works at initialization time,
;; but profits from being in `early-init.el`
(setq default-frame-alist '((tool-bar-lines . 0)))
;; Other possibilities which would need to go in `init.el`, though, include:
;(tool-bar-mode -1)
;(set-frame-parameter nil 'tool-bar-lines 0)
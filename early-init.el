;; -*- lexical-binding: t -*-

;; Some performance optimizations
(let ((previous-file-name-handler-alist file-name-handler-alist))
  (setq gc-cons-threshold (* gc-cons-threshold 2 2 2 2)
	read-process-output-max (* 1024 1024)
	file-name-handler-alist nil)
  (add-hook 'after-init-hook
	    (lambda ()
	      ;; TODO Reset the GC as well?
	      (setq file-name-handler-alist previous-file-name-handler-alist))))

;; Load site specific stuff, e.g. values for the variables above
(load (expand-file-name "site" user-emacs-directory) 'noerror)

;; Source: https://github.com/nilcons/emacs-use-package-fast/blob/a9cc00c/README.md#the-missing-utility-steal-load-path-from-packageel
;;;;;;;;;;;;;;;;;; PULL REQUEST STARTS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Disable package initialize after us.  We either initialize it
;; anyway in case of interpreted .emacs, or we don't want slow
;; initizlization in case of byte-compiled .emacs.elc.
(setq package-enable-at-startup nil)
;; set use-package-verbose to t for interpreted .emacs,
;; and to nil for byte-compiled .emacs.elc
(eval-and-compile
  (setq use-package-verbose (not (bound-and-true-p byte-compile-current-file))))
;; Add the macro generated list of package.el loadpaths to load-path.
(mapc (lambda (add) (add-to-list 'load-path add))
      (eval-when-compile
	;; jules: The following two lines adapt this to Cask
	(require 'package)
	(setq package-user-dir (expand-file-name ".cask/27.1/elpa" user-emacs-directory))
	(package-initialize)
	(let ((package-user-dir-real (file-truename package-user-dir)))
	  ;; The reverse is necessary, because outside we mapc
	  ;; add-to-list element-by-element, which reverses.
	  (nreverse (apply #'nconc
			   ;; Only keep package.el provided loadpaths.
			   (mapcar (lambda (path)
				     (if (string-prefix-p package-user-dir-real path)
					 (list path)
				       nil))
				   load-path))))))
;;;;;;;;;;;;;;;;;; PULL REQUEST  ENDS  HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Hide the toolbar; there are multiple ways to do this,
;; of which we currently use the cheapest but least flexible.
;; This only works at initialization time,
;; but profits from being in `early-init.el`
(setq default-frame-alist '((tool-bar-lines . 0)))
;; Other possibilities which would need to go in `init.el`, though, include:
;;(tool-bar-mode -1)
;;(set-frame-parameter nil 'tool-bar-lines 0)

(defun jk/get-font-size ()
  (face-attribute 'default :height))
(defvar jk/original-font-size (jk/get-font-size))
(set-face-attribute 'default nil :height 240)

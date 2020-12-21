(eval-when-compile
  (require 'use-package))

(use-package bind-key)

;; Appearance

;; Set font if you wish
;; (let ((font "Source Code Pro"))
;;   (when (member font (font-family-list))
;;     (set-face-attribute 'default nil :family font)))

;; TODO It's not nice that this returns another scale than `set-font-size`
;;   but it's more convenient like this for now ...
(defun get-font-size ()
  ;; TODO Is this right? Pass a frame? What face to use?!
  (face-attribute 'default :height))

(defun scale-org-latex-fonts (new-size)
  ;; TODO Maybe this should just assume a fixed scale?
  ;; TODO Is it even guaranteed that `(face-attribute 'default :height)` is what you want?
  (let* ((old-size (get-font-size))
	 (old-scale (plist-get org-format-latex-options :scale))
	 (scale (/ new-size (float old-size)))
	 (new-scale (* scale old-scale)))
    (setq org-format-latex-options
	  (plist-put org-format-latex-options
		     :scale new-scale))))

;; TODO You hardly ever change the font size at runtime;
;;   maybe this could just set some default frame attribute?
;;   Which could then happen in `early-init.el`?
(defun set-font-size (n)
  (interactive "NSize: ")
  (let ((new-size (* 10 n)))
    (when (boundp 'org-format-latex-options)
      (scale-org-latex-fonts new-size))
    (set-face-attribute 'default nil :height new-size)))
(with-eval-after-load "org"
  (scale-org-latex-fonts (get-font-size)))

(setq inhibit-startup-screen t)

(use-package solarized-dark-theme
  :config
  (load-theme 'solarized-dark t))

(use-package hl-line
  :config
  (global-hl-line-mode))

;; Highlighting whitespace

(use-package whitespace
  :config
  (setq whitespace-style '(face trailing empty tabs)
	whitespace-tab 'highlight)
  (global-whitespace-mode)

  (use-package magit
    :defer t
    :config
    (defun jk/prevent-whitespace-mode-for-magit ()
      (not (derived-mode-p 'magit-mode)))
    (add-function :before-while whitespace-enable-predicate
		  'jk/prevent-whitespace-mode-for-magit)))

;; Long lines

;; 80 columns indicator

(define-globalized-minor-mode global-fci-mode
  fci-mode
  (lambda ()
    (fci-mode)))
(global-fci-mode)
(defun auto-fci-mode ()
  (if (> (window-width) (or fci-rule-column fill-column))
      (fci-mode 1)
    (fci-mode 0)))
(add-hook 'after-change-major-mode-hook 'auto-fci-mode)
(add-hook 'window-configuration-change-hook 'auto-fci-mode)

;; Wrapping

(setq fci-handle-truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; Magit

(use-package magit
  :bind ([?\C-c ?g] . magit-status)
  :config
  (setq magit-last-seen-setup-instructions "1.4.0"))

;; ido

(use-package ido
  :config
  (ido-mode)
  (ido-everywhere)

  (use-package magit-extras
    :bind (:map ido-common-completion-map
		([?\C-x ?g] . ido-enter-magit-status)))

  (use-package magit-utils
    :after magit
    :config
    (setq magit-completing-read-function 'magit-ido-completing-read))

  (use-package ido-vertical-mode
    :config
    (ido-vertical-mode))

  (use-package ido-completing-read+
    :config
    (ido-ubiquitous-mode)))

;; Evil

(use-package evil
  :init
  (setq evil-want-keybinding nil)

  (use-package undo-tree
    :config
    (global-undo-tree-mode))

  :custom
  (evil-undo-system 'undo-tree)

  :config
  (evil-mode)

  (use-package evil-surround
    :config
    (global-evil-surround-mode))

  (use-package evil-collection
    :config
    (evil-collection-init))

  (use-package evil-search
    :config
    (evil-select-search-module 'evil-search-module 'evil-search))

  (use-package evil-magit
    :after magit)

  ;; Ace integration
  (use-package evil-integration
    :bind
    (:map evil-motion-state-map
	  ([?g ? ] . evil-ace-jump-char-mode)
	  ([?g ?	] . evil-ace-jump-char-to-mode)
	  ([?g ?b] . evil-ace-jump-word-mode)
	  ([?g return] . evil-ace-jump-line-mode)))

  (use-package org
    :defer t
    :config

    (use-package evil-org
      :hook (org-mode . evil-org-mode)
      :config
      (evil-org-set-key-theme '(navigation insert textobjects additional calendar)))

    (use-package evil-org-agenda
      :config
      (evil-org-agenda-set-keys))))

;; Path
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; Keep everything in one directory

;; Backups

(setq backup-directory-alist
      `((".*" . ,(file-name-as-directory
		  (expand-file-name "backups"
				    user-emacs-directory)))))
(let ((auto-save-directory (expand-file-name "auto-save" user-emacs-directory)))
  ;; Ensure the auto-save directory exists
  (mkdir auto-save-directory 'ignore-existing)
  (setq auto-save-file-name-transforms
	`((".*" ,(file-name-as-directory auto-save-directory) t))))

;; Session files
(defun emacs-session-filename--subdir (orig-fn session-id)
  (expand-file-name session-id
		    (expand-file-name "sessions"
				      user-emacs-directory)))
(advice-add 'emacs-session-filename :around #'emacs-session-filename--subdir)

;; Remember cursor position accross sessions

(use-package saveplace
  :config
  (setq save-place-file (expand-file-name "save-place" user-emacs-directory))
  (save-place-mode))

;; Allow multiple "nested" `.dir-locals.el` files
;; Source: http://emacs.stackexchange.com/a/5537

(defun file-name-directory-nesting-helper (name previous-name accumulator)
  (if (string= name previous-name)
      accumulator         ; stop when names stop changing (at the top)
    (file-name-directory-nesting-helper
     (directory-file-name (file-name-directory name))
     name
     (cons name accumulator))))

(defun file-name-directory-nesting (name)
  (file-name-directory-nesting-helper (expand-file-name name) "" ()))

(defun hack-dir-local-variables-chained-advice (orig)
  "Apply dir-local settings from the whole directory hierarchy,
from the top down."
  (let ((original-buffer-file-name (buffer-file-name))
	(nesting (file-name-directory-nesting (or (buffer-file-name)
						  default-directory))))
    (unwind-protect
	(dolist (name nesting)
	  ;; make it look like we're in a directory higher up in the
	  ;; hierarchy; note that the file we're "visiting" does not
	  ;; have to exist
	  (setq buffer-file-name (expand-file-name "ignored" name))
	  (funcall orig))
      ;; cleanup
      (setq buffer-file-name original-buffer-file-name))))

(advice-add 'hack-dir-local-variables :around
	    #'hack-dir-local-variables-chained-advice)

;; Automatically reload changed files from disk
(use-package autorevert
  :config
  (global-auto-revert-mode))

;; Org

(with-eval-after-load "org"
  (require 'org-inlinetask)

  ;; TODO Why is this even necessary?
  (setcdr (assq 'system org-file-apps-gnu)
	  (lambda (file &rest args)
	    (call-process "xdg-open" nil 0 nil file)))
  ;; TODO This seems like kind of a hack;
  ;;   shouldn't we just remove "pdf" from the `auto-mode-alist`?
  (add-to-list 'org-file-apps '("pdf" . system))
  (add-to-list 'org-file-apps '("ods" . system))

  (org-babel-do-load-languages 'org-babel-load-languages
			       '((shell . t)
				 (latex . t)
				 (python . t)))

  ;; Make (inline) code use a monospaced font
  (set-face-attribute 'org-code nil :family "Monospace"))

;; Use IDs for linking if they are there
(setq org-id-link-to-org-use-id 'use-existing)

;; Links
(global-set-key (kbd "C-c l") 'org-store-link)

;; Indentation
(setq org-startup-indented t)

;; Highlighting in code blocks
(setq org-src-fontify-natively t)

;; Programming

(use-package prog-mode
  :config
  (use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))
  (use-package lsp-mode :hook (prog-mode . lsp))
  (use-package highlight-indent-guides
    :hook (prog-mode . highlight-indent-guides-mode)
    :config
    (setq highlight-indent-guides-method 'character))

  (defun jk/no-tabs ()
    (setq indent-tabs-mode nil)))

;; Rust

(use-package rust-mode
  :mode "\\.rs\\'"
  :config

  (use-package lsp-mode
    :config
    (setq lsp-rust-server 'rust-analyzer))

  (add-hook 'rust-mode-hook 'jk/no-tabs)

  (use-package cargo
    :hook (rust-mode-hook . cargo-minor-mode)))

;; Ruby

(use-package ruby-mode
  :mode "\\.rb\\'"
  :config
  (add-hook 'ruby-mode-hook 'jk/no-tabs))

;; Lisp

(use-package elisp-mode
  :mode ("\\.el\\'" . emacs-lisp-mode)
  :config
  (use-package paredit
    :hook (emacs-lisp-mode . enable-paredit-mode)))

;; JavaScript & Co.

(use-package js2-mode
  :mode "\\.m?jsx?\\'"
  :config
  (advice-add #'js2-identifier-start-p
	      :after-until
	      (lambda (c) (eq c ?#))))

(use-package typescript-mode
  :mode "\\.tsx?\\'")

(use-package json-mode
  :mode "\\.json\\'"
  :config
  ;; Special settings for `package.json` to appease `npm install --save`
  (defun jk/package-json-hook ()
    (when (string= (file-name-nondirectory buffer-file-name) "package.json")
      (setq indent-tabs-mode nil)
      (set (make-local-variable 'js-indent-level) 2)))
  (add-hook 'json-mode-hook 'jk/package-json-hook))

;; LaTeX

(use-package perl-mode
  :mode "\\`.?latexmkrc\\'")

;; Load Customizations

;; Customize
(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(when (file-readable-p custom-file)
  (load custom-file))

;; Load user defaults file
(load (expand-file-name "default" user-emacs-directory) 'noerror)

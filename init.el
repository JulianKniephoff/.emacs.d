
(defvar jk/cask-path "~/.cask/cask.el"
  "The path where Cask is installed.")

;; Load site specific stuff, e.g. values for the variables above
(load (expand-file-name "site" user-emacs-directory) 'noerror)

(require 'cask jk/cask-path)
(cask-initialize)

(require 'pallet)
(pallet-mode t)

;; Appearance

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
;; Start up maximized
;; This is actually the job of the window manager
;(setq default-frame-alist '((fullscreen . maximized)))

(setq frame-background-mode 'dark)
(mapc 'frame-set-background-mode (frame-list))
(load-theme 'solarized t)

;; Set font size
(set-face-attribute 'default nil :height 360)

(global-hl-line-mode)

;; Highlighting whitespace

(require 'whitespace)

(setq whitespace-style
      '(face trailing empty tab-mark))
(global-whitespace-mode)

;; Long lines

;; 80 columns indicator

(define-globalized-minor-mode global-fci-mode
  fci-mode
  (lambda ()
    (fci-mode 1)))
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

;; Behavior

(ido-mode t)
(ido-vertical-mode t)

;; Evil

(evil-mode)
(global-evil-surround-mode)

;; Path
(exec-path-from-shell-initialize)

;; This seems necessary under Cygwin
;; (setenv "PATH" (concat "/usr/local/bin:/usr/bin:/bin:/usr/sbin:"
;;                        (getenv "PATH")))
;; (add-to-list 'exec-path "/usr/local/bin")
;; (add-to-list 'exec-path "/usr/bin")
;; (add-to-list 'exec-path "/bin")
;; (add-to-list 'exec-path "/usr/sbin")

;; Keep everything in one directory

;; Customize

(setq custom-file (expand-file-name "customize.el"
                                    user-emacs-directory))

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

;; Remember cursor position accross sessions

(require 'saveplace)
(setq save-place-file (expand-file-name "save-place" user-emacs-directory))
(setq-default save-place t)

;; Navigation

(global-set-key (kbd "C-c SPC") 'ace-jump-mode)


;; Capture
(defun jk/new-inbox-entry-file ()
  (expand-file-name (concat (format-time-string "%Y-%m-%d-%H-%M-%S")
                            ".txt")
                    "~/Dropbox/Inbox"))
(setq org-capture-templates
      '((" " "Inbox entry" plain
         (file jk/new-inbox-entry-file)
         "")))
(global-set-key (kbd "C-c c") 'org-capture)

;; Programming

;; Set some sensible indentation defaults for programming modes

(setq-default indent-tabs-mode t
              tab-width 4
              sgml-basic-offset 4
              c-basic-offset 4)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Rust

(add-hook 'rust-mode-hook 'cargo-minor-mode)
(setq racer-cmd (expand-file-name "~/.cargo/bin/racer"))
(setq racer-rust-src-path (expand-file-name "~/src/rust/src"))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; Swift

(setq swift-mode:parenthesized-expression-offset 4)

;; Ruby

(setq ruby-insert-encoding-magic-comment nil)
(defun jk/ruby-indentation-mode-hook ()
  (setq indent-tabs-mode nil))
(add-hook 'ruby-mode-hook 'jk/ruby-indentation-mode-hook)

;; Lisp

(defun jk/emacs-lisp-indentation-mode-hook ()
  (setq indent-tabs-mode nil))
(add-hook 'emacs-lisp-mode-hook 'jk/emacs-lisp-indentation-mode-hook)

(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)

;; JavaScript

(add-to-list 'auto-mode-alist '("\\.js\\'". js2-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb\\'". web-mode))
;; Adopt context-coloring-mode to solarized
;; TODO Should only be used when solarized is active?
;; (custom-theme-set-faces
;;  'solarized
;;  '(context-coloring-level-0-face  ((t :foreground "#839496")))
;;  '(context-coloring-level-1-face  ((t :foreground "#268bd2")))
;;  '(context-coloring-level-2-face  ((t :foreground "#2aa198")))
;;  '(context-coloring-level-3-face  ((t :foreground "#859900")))
;;  '(context-coloring-level-4-face  ((t :foreground "#b58900")))
;;  '(context-coloring-level-5-face  ((t :foreground "#cb4b16")))
;;  '(context-coloring-level-6-face  ((t :foreground "#dc322f")))
;;  '(context-coloring-level-7-face  ((t :foreground "#d33682")))
;;  '(context-coloring-level-8-face  ((t :foreground "#6c71c4")))
;;  '(context-coloring-level-9-face  ((t :foreground "#69b7f0")))
;;  '(context-coloring-level-10-face ((t :foreground "#69cabf")))
;;  '(context-coloring-level-11-face ((t :foreground "#b4c342")))
;;  '(context-coloring-level-12-face ((t :foreground "#deb542")))
;;  '(context-coloring-level-13-face ((t :foreground "#f2804f")))
;;  '(context-coloring-level-14-face ((t :foreground "#ff6e64")))
;;  '(context-coloring-level-15-face ((t :foreground "#f771ac")))
;;  '(context-coloring-level-16-face ((t :foreground "#9ea0e5"))))
;; TODO Does not work
;(add-hook 'js2-mode-hook 'context-coloring-mode)

;; Special settings for `package.json` to appease `npm install --save`
(defun jk/package-json-hook ()
  (when (string= (file-name-nondirectory buffer-file-name) "package.json")
    (setq indent-tabs-mode nil)
    (set (make-local-variable 'js-indent-level) 2)))
(add-hook 'json-mode-hook 'jk/package-json-hook)

;; CSS

(defun jk/css-mode-indentation-hook ()
  (setq c-basic-offset 4))
(add-hook 'css-mode-hook 'jk/css-mode-indentation-hook)

;; LaTeX

(defun jk/latex-mode-indentation-hook ()
  (setq indent-tabs-mode t))
(add-hook 'latex-mode-hook 'jk/latex-mode-indentation-hook)

;; Misc

(setq magit-last-seen-setup-instructions "1.4.0")

(server-start)

;; Load Customizations

;; TODO Why is this loaded twice?
(load custom-file)

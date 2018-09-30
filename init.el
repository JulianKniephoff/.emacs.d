;; This is not needed in our Cask/pallet setup,
;; however, Emacs insists on automatically adding it
;; if it is not here, at least commented out.
;(package-initialize)

(defvar jk/cask-path "~/.cask/cask.el"
  "The path where Cask is installed.")

;; Load site specific stuff, e.g. values for the variables above
(load (expand-file-name "site" user-emacs-directory) 'noerror)

(require 'cask jk/cask-path)
(cask-initialize)

(require 'pallet)
(pallet-mode t)

;; Appearance

;; Set font if you wish
;; (let ((font "Source Code Pro"))
;;   (when (member font (font-family-list))
;;     (set-face-attribute 'default nil :family font)))

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
;; Start up maximized
;; This is actually the job of the window manager
;(setq default-frame-alist '((fullscreen . maximized)))

(setq frame-background-mode 'dark)
(mapc 'frame-set-background-mode (frame-list))
(load-theme 'solarized-dark t)

(global-hl-line-mode)

;; Highlighting whitespace

(require 'whitespace)

(setq whitespace-style
      '(face trailing empty tabs))
(setq whitespace-tab 'highlight)
(global-whitespace-mode)
(defun jk/prevent-whitespace-mode-for-magit ()
  (not (derived-mode-p 'magit-mode)))
(add-function :before-while whitespace-enable-predicate 'jk/prevent-whitespace-mode-for-magit)

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

;; Enable magit in ido
(define-key ido-common-completion-map
  [?\C-x ?g] 'ido-enter-magit-status)

;; Evil

(setq evil-want-integration nil)
(setq evil-want-keybinding nil)
(evil-mode)
(global-evil-surround-mode)
(evil-collection-init)

(evil-select-search-module 'evil-search-module 'evil-search)

(require 'evil-magit)

;; Ace integration
(require 'ace-jump-mode)
(define-key evil-motion-state-map [?g ? ] 'evil-ace-jump-char-mode)
(define-key evil-motion-state-map [?g ?	] 'evil-ace-jump-char-to-mode)
(define-key evil-motion-state-map [?g ?b] 'evil-ace-jump-word-mode)
(define-key evil-motion-state-map [?g return] 'evil-ace-jump-line-mode)

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

(setq save-place-file (expand-file-name "save-place" user-emacs-directory))
(save-place-mode 1)

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

;; Programming

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; C++

(c-set-offset 'arglist-intro '+)
(c-set-offset 'arglist-close 0)

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

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb\\'" . web-mode))
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

;; Interpret latexmk configuration correctly as Perl
(add-to-list 'auto-mode-alist '("latexmkrc\\'" . perl-mode))

;; Magit

(global-set-key [(control c) ?g] 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Org

;; Capture
(setq org-capture-templates
      '((" " "Inbox entry" entry
         (file "~/Dropbox/Org/inbox.org")
         "* %?")
        ("w" "Browser capture" entry
         (file "~/Dropbox/Org/inbox.org")
         "* %:annotation\n%i")))
(global-set-key (kbd "C-c c") 'org-capture)

;; Refile
(setq jk/org-files (directory-files-recursively "~/Dropbox/Org" "\\.org$"))
(setq org-refile-targets '((jk/org-files . (:regexp . "."))))
(setq org-refile-use-outline-path 'file)

;; Agenda
(setq org-agenda-files jk/org-files)
(global-set-key (kbd "C-c a") 'org-agenda)

;; Indentation
(setq org-startup-indented t)

;; LaTeX preview
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.5))

;; Highlighting in code blocks
(setq org-src-fontify-natively t)

;; Misc

(server-start)
(require 'org-protocol)

;; Load Customizations

;; Customize
(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(when (file-readable-p custom-file)
  (load custom-file))

;; Load user defaults file
(load (expand-file-name "default" user-emacs-directory) 'noerror)

;; Set up Cask

(require 'cask "~/opt/cask/cask.el")
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
(set-face-attribute 'default nil :height 280)

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

;; This seems necessary under Cygwin
(setenv "PATH" (concat "/usr/local/bin:/usr/bin:/bin:/usr/sbin:"
                       (getenv "PATH")))
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/bin")
(add-to-list 'exec-path "/usr/sbin")

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

;; Org Mode

(require 'org)

; (setq org-directory "~/Documents/org")

(setq org-log-into-drawer t)

;; Explicitly load the beamer exporter

;; This is necessary for asynchronous exports to work.
(require 'ox-beamer)

;; Links

(global-set-key (kbd "C-c l") 'org-store-link)
(require 'org-id)
(setq org-id-link-to-org-use-id t)

;; Clean outlines

(setq org-startup-indented t)
(setq org-hide-leading-stars t)

;; Create new nodes

(defun jk/new-inbox-entry-file ()
  (expand-file-name (concat (format-time-string "%Y-%m-%d-%H-%M-%S")
                            ".txt")
                    "~/Dropbox/Inbox"))
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      `((" " "Inbox entry" plain
	 (file (jk/new-inbox-entry-file))
         "# -*-org-*-

%?")))

;; org-expiry

(require 'org-expiry)

;; Also insert CREATED timestamps when creating nodes manually

(setq org-expiry-inactive-timestamps t)
;; (org-expiry-insinuate)

;; Log refiling

; (setq org-log-refile 'time)

;; Logging for repetition
(setq org-log-repeat nil)

;; Agenda

(global-set-key (kbd "C-c a") 'org-agenda)

; (load-library "find-lisp")
; (setq org-agenda-files
;       (find-lisp-find-files org-directory "\\.org$"))

(setq org-agenda-span 'day)
(setq org-extend-today-until 4)

(require 'org-habit)
(setq org-habit-show-habits-only-for-today nil)

;; Sorting

(add-to-list 'org-agenda-sorting-strategy
	     '(agenda . (scheduled-up habit-down deadline-up)))

;; Autofocus

(defun jk/org-cmp-tsia (a b)
  (let* ((ma (or (get-text-property 1 'org-marker a))
             (get-text-property 1 'org-hd-marker a))
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

;; Show deadline warnings every day

(eval-after-load "org-agenda"
  '(defun org-agenda-get-deadlines (&optional with-hour)
     "Return the deadline information for agenda display.
When WITH-HOUR is non-nil, only return deadlines with an hour
specification like [h]h:mm."
     (let* ((props (list 'mouse-face 'highlight
                         'org-not-done-regexp org-not-done-regexp
                         'org-todo-regexp org-todo-regexp
                         'org-complex-heading-regexp org-complex-heading-regexp
                         'help-echo
                         (format "mouse-2 or RET jump to org file %s"
                                 (abbreviate-file-name buffer-file-name))))
            (regexp (if with-hour
                        org-deadline-time-hour-regexp
                      org-deadline-time-regexp))
            (todayp (org-agenda-todayp date)) ; DATE bound by calendar
            (d1 (calendar-absolute-from-gregorian date)) ; DATE bound by calendar
            (dl0 (car org-agenda-deadline-leaders))
            (dl1 (nth 1 org-agenda-deadline-leaders))
            (dl2 (or (nth 2 org-agenda-deadline-leaders) dl1))
            d2 diff dfrac wdays pos pos1 category category-pos level
            tags suppress-prewarning ee txt head face s todo-state
            show-all upcomingp donep timestr warntime inherited-tags ts-date)
       (goto-char (point-min))
       (while (re-search-forward regexp nil t)
         (catch :skip
           (org-agenda-skip)
           (setq s (match-string 1)
                 txt nil
                 pos (1- (match-beginning 1))
                 todo-state (save-match-data (org-get-todo-state))
                 show-all (or (eq org-agenda-repeating-timestamp-show-all t)
                              (member todo-state
                                      org-agenda-repeating-timestamp-show-all))
                 d2 (org-time-string-to-absolute
                     s d1 'past show-all (current-buffer) pos)
                 diff (- d2 d1))
           (setq suppress-prewarning
                 (let ((ds (and org-agenda-skip-deadline-prewarning-if-scheduled
                                (let ((item (buffer-substring (point-at-bol)
                                                              (point-at-eol))))
                                  (save-match-data
                                    (and (string-match
                                          org-scheduled-time-regexp item)
                                         (match-string 1 item)))))))
                   (cond
                    ((not ds) nil)
                    ;; The current item has a scheduled date (in ds), so
                    ;; evaluate its prewarning lead time.
                    ((integerp org-agenda-skip-deadline-prewarning-if-scheduled)
                     ;; Use global prewarning-restart lead time.
                     org-agenda-skip-deadline-prewarning-if-scheduled)
                    ((eq org-agenda-skip-deadline-prewarning-if-scheduled
                         'pre-scheduled)
                     ;; Set prewarning to no earlier than scheduled.
                     (min (- d2 (org-time-string-to-absolute
                                 ds d1 'past show-all (current-buffer) pos))
                          org-deadline-warning-days))
                    ;; Set prewarning to deadline.
                    (t 0))))
           (setq wdays (if suppress-prewarning
                           (let ((org-deadline-warning-days suppress-prewarning))
                             (org-get-wdays s))
                         (org-get-wdays s))
                 dfrac (- 1 (/ (* 1.0 diff) (max wdays 1)))
                 upcomingp (and todayp (> diff 0)))
           ;; NOTE was
           ;; upcomingp (and todayp (> diff 0)))
           ;; When to show a deadline in the calendar:
           ;; If the expiration is within wdays warning time.
           ;; Past-due deadlines are only shown on the current date
           (if (or (and (<= diff wdays)
                        (not org-agenda-only-exact-dates))
                   (= diff 0))
               ;; NOTE was
               ;; (if (and (or (and (<= diff wdays)
               ;; 		  (and todayp (not org-agenda-only-exact-dates)))
               ;; 	     (= diff 0)))
               (save-excursion
                 ;; (setq todo-state (org-get-todo-state))
                 (setq donep (member todo-state org-done-keywords))
                 (if (and donep
                          (or org-agenda-skip-deadline-if-done
                              (not (= diff 0))))
                     (setq txt nil)
                   (setq category (org-get-category)
                         warntime (get-text-property (point) 'org-appt-warntime)
                         category-pos (get-text-property (point) 'org-category-position))
                   (if (not (re-search-backward "^\\*+[ \t]+" nil t))
                       (throw :skip nil)
                     (goto-char (match-end 0))
                     (setq pos1 (match-beginning 0))
                     (setq level (make-string (org-reduced-level (org-outline-level)) ? ))
                     (setq inherited-tags
                           (or (eq org-agenda-show-inherited-tags 'always)
                               (and (listp org-agenda-show-inherited-tags)
                                    (memq 'agenda org-agenda-show-inherited-tags))
                               (and (eq org-agenda-show-inherited-tags t)
                                    (or (eq org-agenda-use-tag-inheritance t)
                                        (memq 'agenda org-agenda-use-tag-inheritance))))
                           tags (org-get-tags-at pos1 (not inherited-tags)))
                     (setq head (buffer-substring
                                 (point)
                                 (progn (skip-chars-forward "^\r\n")
                                        (point))))
                     (if (string-match " \\([012]?[0-9]:[0-9][0-9]\\)" s)
                         (setq timestr
                               (concat (substring s (match-beginning 1)) " "))
                       (setq timestr 'time))
                     (setq txt (org-agenda-format-item
                                (cond ((= diff 0) dl0)
                                      ((> diff 0)
                                       (if (functionp dl1)
                                           (funcall dl1 diff date)
                                         (format dl1 diff)))
                                      (t
                                       (if (functionp dl2)
                                           (funcall dl2 diff date)
                                         (format dl2 (if (string= dl2 dl1)
                                                         diff (abs diff))))))
                                head level category tags
                                (if (not (= diff 0)) nil timestr)))))
                 (when txt
                   (setq face (org-agenda-deadline-face dfrac))
                   (org-add-props txt props
                     'org-marker (org-agenda-new-marker pos)
                     'warntime warntime
                     'level level
                     'ts-date d2
                     'org-hd-marker (org-agenda-new-marker pos1)
                     'priority (+ (- diff)
                                  (org-get-priority txt))
                     'org-category category
                     'org-category-position category-pos
                     'todo-state todo-state
                     'type (if upcomingp "upcoming-deadline" "deadline")
                     'date (if upcomingp date d2)
                     'face (if donep 'org-agenda-done face)
                     'undone-face face 'done-face 'org-agenda-done)
                   (push txt ee))))))
       (nreverse ee))))

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

;; Set some sensible indentation defaults for programming modes

(setq-default indent-tabs-mode t
              tab-width 4
              sgml-basic-offset 4
              c-basic-offset 4)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Babel

(setq org-src-fontify-natively t)
(setq org-src-preserve-indentation t)
(org-babel-do-load-languages 'org-babel-load-languages
                             '((ruby . t)))

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
(custom-theme-set-faces
 'solarized
 '(context-coloring-level-0-face  ((t :foreground "#839496")))
 '(context-coloring-level-1-face  ((t :foreground "#268bd2")))
 '(context-coloring-level-2-face  ((t :foreground "#2aa198")))
 '(context-coloring-level-3-face  ((t :foreground "#859900")))
 '(context-coloring-level-4-face  ((t :foreground "#b58900")))
 '(context-coloring-level-5-face  ((t :foreground "#cb4b16")))
 '(context-coloring-level-6-face  ((t :foreground "#dc322f")))
 '(context-coloring-level-7-face  ((t :foreground "#d33682")))
 '(context-coloring-level-8-face  ((t :foreground "#6c71c4")))
 '(context-coloring-level-9-face  ((t :foreground "#69b7f0")))
 '(context-coloring-level-10-face ((t :foreground "#69cabf")))
 '(context-coloring-level-11-face ((t :foreground "#b4c342")))
 '(context-coloring-level-12-face ((t :foreground "#deb542")))
 '(context-coloring-level-13-face ((t :foreground "#f2804f")))
 '(context-coloring-level-14-face ((t :foreground "#ff6e64")))
 '(context-coloring-level-15-face ((t :foreground "#f771ac")))
 '(context-coloring-level-16-face ((t :foreground "#9ea0e5"))))
;; TODO Does not work
;(add-hook 'js2-mode-hook 'context-coloring-mode)

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

(load custom-file)

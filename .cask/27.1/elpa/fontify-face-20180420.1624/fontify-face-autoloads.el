;;; fontify-face-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "fontify-face" "fontify-face.el" (0 0 0 0))
;;; Generated autoloads from fontify-face.el

(autoload 'fontify-face-mode "fontify-face" "\
Fontify symbols representing faces with that face.

If called interactively, enable Fontify-Face mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "fontify-face" '("fontify-face-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; fontify-face-autoloads.el ends here

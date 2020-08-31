;;; evil-ledger-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evil-ledger" "evil-ledger.el" (0 0 0 0))
;;; Generated autoloads from evil-ledger.el

(autoload 'evil-ledger-mode "evil-ledger" "\
Minor mode for more evil in `ledger-mode'.

If called interactively, enable Evil-Ledger mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The following keys are available in `evil-ledger-mode':

\\{evil-ledger-mode-map}

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "evil-ledger" '("evil-ledger-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-ledger-autoloads.el ends here

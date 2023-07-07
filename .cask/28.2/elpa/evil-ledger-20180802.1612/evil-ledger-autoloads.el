;;; evil-ledger-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evil-ledger" "evil-ledger.el" (0 0 0 0))
;;; Generated autoloads from evil-ledger.el

(autoload 'evil-ledger-mode "evil-ledger" "\
Minor mode for more evil in `ledger-mode'.

This is a minor mode.  If called interactively, toggle the
`Evil-Ledger mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `evil-ledger-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

The following keys are available in `evil-ledger-mode':

\\{evil-ledger-mode-map}

\(fn &optional ARG)" t nil)

(register-definition-prefixes "evil-ledger" '("evil-ledger-"))

;;;***

;;;### (autoloads nil nil ("evil-ledger-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-ledger-autoloads.el ends here

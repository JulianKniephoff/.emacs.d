;;; pkgbuild-mode-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from pkgbuild-mode.el

(autoload 'pkgbuild-mode "pkgbuild-mode" "\
Major mode for editing PKGBUILD files.
This is much like `shell-script-mode' mode.
Turning on pkgbuild mode calls the value of the variable `pkgbuild-mode-hook'
with no args, if that value is non-nil.

(fn)" t)
(add-to-list 'auto-mode-alist '("/PKGBUILD\\'" . pkgbuild-mode))
(register-definition-prefixes "pkgbuild-mode" '("pkgbuild-"))

;;; End of scraped data

(provide 'pkgbuild-mode-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; pkgbuild-mode-autoloads.el ends here
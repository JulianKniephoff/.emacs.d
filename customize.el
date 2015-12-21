(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "1297a022df4228b81bc0436230f211bad168a117282c20ddcba2db8c6a200743" default)))
 '(doc-view-continuous t)
 '(safe-local-variable-values
   (quote
    ((TeX-master "loesung_02")
     (eval setq-local org-export-async-init-file
           (expand-file-name "init-export.el"))
     (org-export-allow-bind-keywords . t)
     (eval setq org-export-async-init-file
           (expand-file-name "init-export.el"))
     (eval add-hook
           (quote after-save-hook)
           (lambda nil
             (org-latex-export-to-latex t))
           nil t)
     (eval add-to-list
           (quote org-latex-classes)
           (quote
            ("ausarbeitung" "\\documentclass{ausarbeitung}
                                     [NO-DEFAULT-PACKAGES]")))
     (eval add-hook
           (quote after-save-hook)
           (lambda nil
             (org-latex-export-to-pdf t))
           nil t)
     (eval add-hook
           (quote after-save-hook)
           (lambda nil
             (org-beamer-export-to-pdf t))
           nil t)
     (org-beamer-outline-frame-title . "Übersicht")
     (sgml-basic-offset . 4)
     (tab-width 4)
     (sgml-basic-offset 4)
     (sgml-basic-offset 4 tab-width 4)
     (eval progn
           (add-to-list
            (quote org-latex-packages-alist)
            "\\usepackage{jkmath}"))
     (org-agenda-tag-filter-preset "-@Ruby" "-@MacBook")
     (eval progn
           (c-set-offset
            (quote func-decl-cont)
            (quote ++)))
     (org-tags-exclude-from-inheritance "Hotspot")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

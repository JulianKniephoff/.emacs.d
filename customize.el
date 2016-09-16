(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   (quote
    ((eval setq js2-additional-externs
           (nconc
            (append js2-node-externs js2-browser-externs)
            js2-additional-externs))
     (eval nconc
           (append js2-node-externs js2-browser-externs)
           js2-additional-externs)
     (js2-include-browser-externs . t)
     (js2-include-node-externs . t)
     (eval add-to-list
           (quote js2-additional-externs)
           "exports")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

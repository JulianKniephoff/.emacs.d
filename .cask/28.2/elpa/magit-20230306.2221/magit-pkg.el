(define-package "magit" "20230306.2221" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (compat "29.1.3.4")
    (dash "20221013")
    (git-commit "20230101")
    (magit-section "20230101")
    (transient "20230201")
    (with-editor "20230118"))
  :commit "7fd62479b1127a4df3b073084fba3fd229f30f4c" :authors
  '(("Marius Vollmer" . "marius.vollmer@gmail.com")
    ("Jonas Bernoulli" . "jonas@bernoul.li"))
  :maintainer
  '("Jonas Bernoulli" . "jonas@bernoul.li")
  :keywords
  '("git" "tools" "vc")
  :url "https://github.com/magit/magit")
;; Local Variables:
;; no-byte-compile: t
;; End:

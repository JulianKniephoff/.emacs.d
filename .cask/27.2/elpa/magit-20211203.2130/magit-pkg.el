(define-package "magit" "20211203.2130" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (dash "20210826")
    (git-commit "20211004")
    (magit-section "20211004")
    (transient "20210920")
    (with-editor "20211001"))
  :commit "b6a103b6bf62dfea556f3e5523e52d1a16228ea8" :authors
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

(define-package "magit" "20220516.2019" "A Git porcelain inside Emacs."
  '((emacs "25.1")
    (compat "28.1.1.0")
    (dash "20210826")
    (git-commit "20220222")
    (magit-section "20220325")
    (transient "20220325")
    (with-editor "20220318"))
  :commit "5a7519fd3d56522b1c6a1601a12ae0f4717c26a7" :authors
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

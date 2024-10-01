;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "magit" "20240930.1805"
  "A Git porcelain inside Emacs."
  '((emacs         "26.1")
    (compat        "30.0.0.0")
    (dash          "2.19.1")
    (magit-section "4.1.0")
    (seq           "2.24")
    (transient     "0.7.5")
    (with-editor   "3.4.2"))
  :url "https://github.com/magit/magit"
  :commit "155b5364caf3dd317723a1b47f355fe4ef96e5c1"
  :revdesc "155b5364caf3"
  :keywords '("git" "tools" "vc")
  :authors '(("Marius Vollmer" . "marius.vollmer@gmail.com")
             ("Jonas Bernoulli" . "emacs.magit@jonas.bernoulli.dev"))
  :maintainers '(("Jonas Bernoulli" . "emacs.magit@jonas.bernoulli.dev")
                 ("Kyle Meyer" . "kyle@kyleam.com")))

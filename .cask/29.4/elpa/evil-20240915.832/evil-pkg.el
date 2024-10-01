;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "evil" "20240915.832"
  "Extensible vi layer."
  '((emacs    "24.1")
    (cl-lib   "0.5")
    (goto-chg "1.6")
    (nadvice  "0.3"))
  :url "https://github.com/emacs-evil/evil"
  :commit "ea552efeeb809898932f55d1690da9cbe8ef5fa1"
  :revdesc "ea552efeeb80"
  :keywords '("emulations")
  :maintainers '(("Tom Dalziel" . "tom.dalziel@gmail.com")))

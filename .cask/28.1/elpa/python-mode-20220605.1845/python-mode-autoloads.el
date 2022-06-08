;;; python-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "python-mode" "python-mode.el" (0 0 0 0))
;;; Generated autoloads from python-mode.el

(autoload 'rx-to-string "python-mode" "\
Translate FORM from `rx' sexp syntax into a string regexp.
The arguments to `literal' and `regexp' forms inside FORM must be
constant strings.
If NO-GROUP is non-nil, don't bracket the result in a non-capturing
group.

For extending the `rx' notation in FORM, use `rx-define' or `rx-let-eval'.

\(fn FORM &optional NO-GROUP)" nil nil)

(autoload 'rx "python-mode" "\
Translate regular expressions REGEXPS in sexp form to a regexp string.
Each argument is one of the forms below; RX is a subform, and RX... stands
for zero or more RXs.  For details, see Info node `(elisp) Rx Notation'.
See `rx-to-string' for the corresponding function.

STRING         Match a literal string.
CHAR           Match a literal character.

\(seq RX...)    Match the RXs in sequence.  Alias: :, sequence, and.
\(or RX...)     Match one of the RXs.  Alias: |.

\(zero-or-more RX...) Match RXs zero or more times.  Alias: 0+.
\(one-or-more RX...)  Match RXs one or more times.  Alias: 1+.
\(zero-or-one RX...)  Match RXs or the empty string.  Alias: opt, optional.
\(* RX...)       Match RXs zero or more times; greedy.
\(+ RX...)       Match RXs one or more times; greedy.
\(? RX...)       Match RXs or the empty string; greedy.
\(*? RX...)      Match RXs zero or more times; non-greedy.
\(+? RX...)      Match RXs one or more times; non-greedy.
\(?? RX...)      Match RXs or the empty string; non-greedy.
\(= N RX...)     Match RXs exactly N times.
\(>= N RX...)    Match RXs N or more times.
\(** N M RX...)  Match RXs N to M times.  Alias: repeat.
\(minimal-match RX)  Match RX, with zero-or-more, one-or-more, zero-or-one
                and aliases using non-greedy matching.
\(maximal-match RX)  Match RX, with zero-or-more, one-or-more, zero-or-one
                and aliases using greedy matching, which is the default.

\(any SET...)    Match a character from one of the SETs.  Each SET is a
                character, a string, a range as string \"A-Z\" or cons
                (?A . ?Z), or a character class (see below).  Alias: in, char.
\(not CHARSPEC)  Match one character not matched by CHARSPEC.  CHARSPEC
                can be a character, single-char string, (any ...), (or ...),
                (intersection ...), (syntax ...), (category ...),
                or a character class.
\(intersection CHARSET...) Match all CHARSETs.
                CHARSET is (any...), (not...), (or...) or (intersection...),
                a character or a single-char string.
not-newline     Match any character except a newline.  Alias: nonl.
anychar         Match any character.  Alias: anything.
unmatchable     Never match anything at all.

CHARCLASS       Match a character from a character class.  One of:
 alpha, alphabetic, letter   Alphabetic characters (defined by Unicode).
 alnum, alphanumeric         Alphabetic or decimal digit chars (Unicode).
 digit, numeric, num         0-9.
 xdigit, hex-digit, hex      0-9, A-F, a-f.
 cntrl, control              ASCII codes 0-31.
 blank                       Horizontal whitespace (Unicode).
 space, whitespace, white    Chars with whitespace syntax.
 lower, lower-case           Lower-case chars, from current case table.
 upper, upper-case           Upper-case chars, from current case table.
 graph, graphic              Graphic characters (Unicode).
 print, printing             Whitespace or graphic (Unicode).
 punct, punctuation          Not control, space, letter or digit (ASCII);
                              not word syntax (non-ASCII).
 word, wordchar              Characters with word syntax.
 ascii                       ASCII characters (codes 0-127).
 nonascii                    Non-ASCII characters (but not raw bytes).

\(syntax SYNTAX)  Match a character with syntax SYNTAX, being one of:
  whitespace, punctuation, word, symbol, open-parenthesis,
  close-parenthesis, expression-prefix, string-quote,
  paired-delimiter, escape, character-quote, comment-start,
  comment-end, string-delimiter, comment-delimiter

\(category CAT)   Match a character in category CAT, being one of:
  space-for-indent, base, consonant, base-vowel,
  upper-diacritical-mark, lower-diacritical-mark, tone-mark, symbol,
  digit, vowel-modifying-diacritical-mark, vowel-sign,
  semivowel-lower, not-at-end-of-line, not-at-beginning-of-line,
  alpha-numeric-two-byte, chinese-two-byte, greek-two-byte,
  japanese-hiragana-two-byte, indian-two-byte,
  japanese-katakana-two-byte, strong-left-to-right,
  korean-hangul-two-byte, strong-right-to-left, cyrillic-two-byte,
  combining-diacritic, ascii, arabic, chinese, ethiopic, greek,
  korean, indian, japanese, japanese-katakana, latin, lao,
  tibetan, japanese-roman, thai, vietnamese, hebrew, cyrillic,
  can-break

Zero-width assertions: these all match the empty string in specific places.
 line-start         At the beginning of a line.  Alias: bol.
 line-end           At the end of a line.  Alias: eol.
 string-start       At the start of the string or buffer.
                     Alias: buffer-start, bos, bot.
 string-end         At the end of the string or buffer.
                     Alias: buffer-end, eos, eot.
 point              At point.
 word-start         At the beginning of a word.  Alias: bow.
 word-end           At the end of a word.  Alias: eow.
 word-boundary      At the beginning or end of a word.
 not-word-boundary  Not at the beginning or end of a word.
 symbol-start       At the beginning of a symbol.
 symbol-end         At the end of a symbol.

\(group RX...)  Match RXs and define a capture group.  Alias: submatch.
\(group-n N RX...) Match RXs and define capture group N.  Alias: submatch-n.
\(backref N)    Match the text that capture group N matched.

\(literal EXPR) Match the literal string from evaluating EXPR at run time.
\(regexp EXPR)  Match the string regexp from evaluating EXPR at run time.
\(eval EXPR)    Match the rx sexp from evaluating EXPR at macro-expansion
                (compile) time.

Additional constructs can be defined using `rx-define' and `rx-let',
which see.

\(fn REGEXPS...)" nil t)

(autoload 'rx-let-eval "python-mode" "\
Evaluate BODY with local BINDINGS for `rx-to-string'.
BINDINGS, after evaluation, is a list of definitions each on the form
\(NAME [(ARGS...)] RX), in effect for calls to `rx-to-string'
in BODY.

For bindings without an ARGS list, NAME is defined as an alias
for the `rx' expression RX.  Where ARGS is supplied, NAME is
defined as an `rx' form with ARGS as argument list.  The
parameters are bound from the values in the (NAME ...) form and
are substituted in RX.  ARGS can contain `&rest' parameters,
whose values are spliced into RX where the parameter name occurs.

Any previous definitions with the same names are shadowed during
the expansion of BODY only.
For extensions when using the `rx' macro, use `rx-let'.
To make global rx extensions, use `rx-define'.
For more details, see Info node `(elisp) Extending Rx'.

\(fn BINDINGS BODY...)" nil t)

(function-put 'rx-let-eval 'lisp-indent-function '1)

(autoload 'rx-let "python-mode" "\
Evaluate BODY with local BINDINGS for `rx'.
BINDINGS is an unevaluated list of bindings each on the form
\(NAME [(ARGS...)] RX).
They are bound lexically and are available in `rx' expressions in
BODY only.

For bindings without an ARGS list, NAME is defined as an alias
for the `rx' expression RX.  Where ARGS is supplied, NAME is
defined as an `rx' form with ARGS as argument list.  The
parameters are bound from the values in the (NAME ...) form and
are substituted in RX.  ARGS can contain `&rest' parameters,
whose values are spliced into RX where the parameter name occurs.

Any previous definitions with the same names are shadowed during
the expansion of BODY only.
For local extensions to `rx-to-string', use `rx-let-eval'.
To make global rx extensions, use `rx-define'.
For more details, see Info node `(elisp) Extending Rx'.

\(fn BINDINGS BODY...)" nil t)

(function-put 'rx-let 'lisp-indent-function '1)

(autoload 'rx-define "python-mode" "\
Define NAME as a global `rx' definition.
If the ARGS list is omitted, define NAME as an alias for the `rx'
expression RX.

If the ARGS list is supplied, define NAME as an `rx' form with
ARGS as argument list.  The parameters are bound from the values
in the (NAME ...) form and are substituted in RX.
ARGS can contain `&rest' parameters, whose values are spliced
into RX where the parameter name occurs.

Any previous global definition of NAME is overwritten with the new one.
To make local rx extensions, use `rx-let' for `rx',
`rx-let-eval' for `rx-to-string'.
For more details, see Info node `(elisp) Extending Rx'.

\(fn NAME [(ARGS...)] RX)" nil t)

(function-put 'rx-define 'lisp-indent-function 'defun)

(eval-and-compile (defun rx--pcase-macroexpander (&rest regexps) "A pattern that matches strings against `rx' REGEXPS in sexp form.\nREGEXPS are interpreted as in `rx'.  The pattern matches any\nstring that is a match for REGEXPS, as if by `string-match'.\n\nIn addition to the usual `rx' syntax, REGEXPS can contain the\nfollowing constructs:\n\n  (let REF RX...)  binds the symbol REF to a submatch that matches\n                   the regular expressions RX.  REF is bound in\n                   CODE to the string of the submatch or nil, but\n                   can also be used in `backref'.\n  (backref REF)    matches whatever the submatch REF matched.\n                   REF can be a number, as usual, or a name\n                   introduced by a previous (let REF ...)\n                   construct." (let* ((rx--pcase-vars nil) (regexp (rx--to-expr (rx--pcase-transform (cons 'seq regexps))))) `(and (pred stringp) ,(pcase (length rx--pcase-vars) (0 `(pred (string-match ,regexp))) (1 `(app (lambda (s) (if (string-match ,regexp s) (match-string 1 s) 0)) (and ,(car rx--pcase-vars) (pred (not numberp))))) (nvars `(app (lambda (s) (and (string-match ,regexp s) ,(rx--reduce-right (lambda (a b) `(cons ,a ,b)) (mapcar (lambda (i) `(match-string ,i s)) (number-sequence 1 nvars))))) ,(list '\` (rx--reduce-right #'cons (mapcar (lambda (name) (list '\, name)) (reverse rx--pcase-vars)))))))))))

(define-symbol-prop 'rx--pcase-macroexpander 'edebug-form-spec 'nil)

(define-symbol-prop 'rx 'pcase-macroexpander #'rx--pcase-macroexpander)

(autoload 'py-backward-class-bol "python-mode" "\
Go to beginning of `class', go to BOL.
If already at beginning, go one `class' backward.
Return beginning of `class' if successful, nil otherwise" t nil)

(autoload 'py-backward-def-bol "python-mode" "\
Go to beginning of `def', go to BOL.
If already at beginning, go one `def' backward.
Return beginning of `def' if successful, nil otherwise" t nil)

(autoload 'py-backward-def-or-class-bol "python-mode" "\
Go to beginning of `def-or-class', go to BOL.
If already at beginning, go one `def-or-class' backward.
Return beginning of `def-or-class' if successful, nil otherwise" t nil)

(autoload 'py-forward-class "python-mode" "\
Go to end of class.

Return end of `class' if successful, nil otherwise
Optional ORIG: start position
Optional BOL: go to beginning of line following end-position

\(fn &optional ORIG BOL)" t nil)

(autoload 'py-forward-def "python-mode" "\
Go to end of def.

Return end of `def' if successful, nil otherwise
Optional ORIG: start position
Optional BOL: go to beginning of line following end-position

\(fn &optional ORIG BOL)" t nil)

(autoload 'py-forward-def-or-class "python-mode" "\
Go to end of def-or-class.

Return end of `def-or-class' if successful, nil otherwise
Optional ORIG: start position
Optional BOL: go to beginning of line following end-position

\(fn &optional ORIG BOL)" t nil)

(autoload 'py-auto-completion-mode "python-mode" "\
Run auto-completion

\(fn)" t nil)

(autoload 'python-mode "python-mode" "\
Major mode for editing Python files.

To submit a report, enter `\\[py-submit-bug-report]'
from a`python-mode' buffer.
Do `\\[py-describe-mode]' for detailed documentation.
To see what version of `python-mode' you are running,
enter `\\[py-version]'.

This mode knows about Python indentation,
tokens, comments (and continuation lines.
Paragraphs are separated by blank lines only.

COMMANDS

`py-shell'	Start an interactive Python interpreter in another window
`py-execute-statement'	Send statement at point to Python default interpreter
`py-backward-statement'	Go to the initial line of a simple statement

etc.

See available commands listed in files commands-python-mode at directory doc

VARIABLES

`py-indent-offset'	indentation increment
`py-shell-name'		shell command to invoke Python interpreter
`py-split-window-on-execute'		When non-nil split windows
`py-switch-buffers-on-execute-p'	When non-nil switch to the Python output buffer

\\{python-mode-map}

\(fn)" t nil)

(register-definition-prefixes "python-mode" '("all-mode-setting" "autopair-mode" "flake8" "force-py-shell-name-p-o" "highlight-indent-active" "hs-hide-comments-when-hiding-all" "info-lookup-mode" "ipython" "isympy3" "iypthon" "jython" "pdb-track-stack-from-shell-p" "pep8" "pst-here" "rx-" "stri" "toggle-force-py-shell-name-p" "turn-o" "virtualenv-"))

;;;***

;;;### (autoloads nil nil ("python-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; python-mode-autoloads.el ends here

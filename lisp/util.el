(defun inspect (f o)
  (funcall f o)
  o)

(defmacro comment (&body)
  nil)

(provide 'util)

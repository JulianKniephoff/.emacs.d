(require 'seq)

(defun org-element-property-name-to-keyword (property)
  (intern (concat ":" property)))

(defun org-element-deep-copy (element &optional boundary)
  (let ((boundary (if (listp boundary) boundary (list boundary))))
    (apply #'org-element-adopt-elements
           (org-element-copy element)
           (mapcar #'org-element-deep-copy
                   (seq-filter (lambda (element)
                                 (not (memq (org-element-type element)
                                            boundary)))
                               (org-element-contents element))))))

(defun org-element-set-property (element property value)
  (org-element-put-property element
                            (org-element-property-name-to-keyword
                             property)
                            value)
  (let ((node-property `(node-property
                         (:key ,property :value ,value))))
    (if-let ((property-drawer
              (org-element-map
                  (org-element-contents element)
                  'property-drawer
                #'identity nil 'first-match 'headline)))
        (if-let ((existing-property
                  (org-element-map property-drawer 'node-property
                    (lambda (p)
                      (when (string= (org-element-property :key p)
                                     property)
                        p))
                    nil 'first-match)))
            (org-element-put-property existing-property :value value)
          (org-element-adopt-elements property-drawer node-property))
      (let ((property-drawer
             (list 'property-drawer nil node-property)))
        (if-let ((contents (org-element-contents element)))
            (org-element-insert-before property-drawer (car contents))
          (org-element-adopt-elements element property-drawer))))))

(defun org-element-up (types element)
  (while (and element
              (not (memq (org-element-type element)
                         (if (listp types) types (list types)))))
    (setq element (org-element-property :parent element)))
  element)

(defun org-element-remove-property (element property)
  (org-element-map element 'node-property
    (lambda (p)
      (when (string= property (org-element-property :key p))
        (org-element-extract-element p))))
  (org-element-put-property element
                            (org-element-property-name-to-keyword
                             property)
                            nil))

(defun org-element-go-to (element &optional position)
  (interactive)
  (goto-char (org-element-property (or position :begin) element)))

(defun org-element-find (&optional pos element)
  (interactive)
  (let ((pos (or pos (point)))
        (stack (if element
                   (list element)
                 (org-element-contents (org-element-parse-buffer))))
        found)
    (while stack
      (let ((element (car stack)))
        (when (and (>= pos (org-element-property :begin element))
                   (< pos (org-element-property :end element)))
          (setq found element)
          (setq stack (append stack (org-element-contents element)))))
      (setq stack (cdr stack)))
    found))

(provide 'org-element-x)

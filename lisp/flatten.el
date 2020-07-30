(require 'org-id)

(require 'org-element-x)

(defun flatten-asem (ast)
  (let ((new-ast (org-element-create 'org-data)))
    (org-element-map ast 'headline
      (lambda (hl)
        (when (string-match (concat (make-string 80 ?-) "$")
                            (car (org-element-property :title hl)))
          (apply #'org-element-adopt-elements
                 new-ast (org-element-contents hl))))
      nil nil 'headline)
    new-ast))

(defun flatten (src dest)
  (org-element-map src 'headline
    (lambda (hl)
      (let ((hl-copy (org-element-deep-copy hl 'headline)))
        (if-let ((src-id (org-element-property :SOURCE_ID hl)))
            (let ((original-hl
                   (org-element-map dest 'headline
                     (lambda (hl)
                       (when (string= (org-element-property :ID hl)
                                      src-id)
                         hl))
                     nil 'first-match)))
              (org-element-put-property
               original-hl :title
               (org-element-property :title hl)))
          (let ((id (or (org-element-property :ID hl)
                        (org-id-uuid))))
            (org-element-set-property hl-copy "ID" id)
            (org-element-put-property hl :SOURCE_ID id))
          (when-let ((parent-headline
                      (org-element-lineage hl '(headline))))
            (org-element-set-property hl-copy "PARENT_ID"
                                      (org-element-property
                                       :SOURCE_ID parent-headline)))
          (org-element-put-property hl-copy :level 1)
          (org-element-adopt-elements dest hl-copy)))))
  dest)

(save-window-excursion
  (let (src-ast dest-ast)
    (find-file "~/Dropbox/Org/tree.org")
    (setq src-ast (org-element-parse-buffer))
    (find-file "~/Dropbox/Org/flat.org")
    (setq dest-ast (org-element-parse-buffer))
    (erase-buffer)
    (flatten src-ast dest-ast)
    (insert (org-element-interpret-data dest-ast))))

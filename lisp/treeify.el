(require 'org-element-x)

(save-window-excursion
  (find-file "flat.org")
  (let ((new-ast (org-element-create 'org-data)))
    (org-element-map (org-element-parse-buffer) 'headline
      (lambda (hl)
        (org-element-set-property hl "SOURCE_ID"
                                  (org-element-property :ID hl))
        (org-element-remove-property hl "ID")
        (if-let ((parent-ids (org-element-property :PARENT_ID hl)))
            (progn
              (org-element-remove-property hl "PARENT_ID")
              (dolist (parent-id (split-string parent-ids " "))
                (org-element-map new-ast 'headline
                  (lambda (new-parent)
                    (when (string= parent-id
                                   (org-element-property :SOURCE_ID
                                                         new-parent))
                      (let ((hl (org-element-deep-copy hl)))
                        (org-element-adopt-elements new-parent hl)
                        (org-element-put-property
                         hl :level
                         (1+ (org-element-property :level
                                                   new-parent)))))))))
          (org-element-adopt-elements new-ast hl))))
    (find-file "tree.org")
    (erase-buffer)
    (insert (org-element-interpret-data new-ast))))

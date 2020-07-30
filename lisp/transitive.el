(require 'cl)

(require 'org-element-x)

(save-window-excursion
  (find-file org-db-file)
  (let* ((parents (list "d068e4a2-f0b6-422c-bb16-227b46d07518"))
         (ast
          (apply #'org-element-adopt-elements (org-element-create 'org-data)
                 (org-element-map (org-element-parse-buffer) 'headline
                   (lambda (hl)
                     (when-let ((parent-ids
                                 (org-element-property :PARENT_ID hl)))
                       (when (cl-intersection parents
                                              (split-string parent-ids " ")
                                              :test #'string=)
                         (let ((id (org-element-property :ID hl)))
                           (add-to-list 'parents id nil #'string=)
                           (org-element-put-property hl :ID nil)
                           (org-element-put-property hl
                                                     :SOURCE_ID id))
                         hl)))))))
    (find-file "transitive.org")
    (erase-buffer)
    (insert (org-element-interpret-data ast))))

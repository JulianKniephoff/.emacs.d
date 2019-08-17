(require 'org-id)
(require 'org-element-x)

(defvar org-db-file (expand-file-name "db.org" org-directory))

(defun org-db-insert (&optional element interactive)
  (interactive "i\np")
  (when (not element)
    (save-excursion
      (org-up-heading-safe)
      (setq element (org-element-at-point))))
  (let ((copy (org-element-deep-copy element 'headline))
        (id (or (org-element-property :ID element)
                (org-id-uuid))))
    (org-element-set-property element "SOURCE_ID" id)
    (org-element-remove-property element "ID")
    (when interactive
      (org-delete-property "ID")
      (org-set-property "SOURCE_ID" id))
    (org-element-set-property copy "ID" id)
    (org-element-put-property copy :level 1)
    (save-window-excursion
      (find-file org-db-file)
      (goto-char (point-max))
      (insert (org-element-interpret-data copy)))))

(defun org-db-push ()
  (interactive)
  (let ((db-buffer (find-file-noselect org-db-file)))
    (org-map-region
     (lambda ()
       (when (not (org-entry-get (point) "SOURCE_ID"))
         (org-copy-subtree nil nil nil 'nosubtrees)
         (let (id
               (parent-id (org-entry-get-with-inheritance "SOURCE_ID")))
           (with-current-buffer db-buffer
             (goto-char (point-max))
             (org-paste-subtree 1)
             (setq id (org-id-get-create))
             (when parent-id
               (org-entry-put (point) "PARENT_ID" parent-id)))
           (org-entry-put (point) "SOURCE_ID" id))))
     (point-min) (point-max))))

(provide 'org-db)

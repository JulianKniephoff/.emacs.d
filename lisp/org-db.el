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

(provide 'org-db)

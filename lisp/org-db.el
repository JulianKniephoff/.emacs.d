(require 'org-id)
(require 'org-element-x)
(require 'util)

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
       (let ((parent-id (save-excursion
                          (when (org-up-heading-safe)
                            (org-entry-get (point) "SOURCE_ID")))))
         (org-copy-subtree nil nil nil 'nosubtrees)
         (if-let ((source-id (org-entry-get (point) "SOURCE_ID")))
             (progn
               (let* ((source-marker (org-id-find source-id 'markerp))
                      (source-position
                       (marker-position source-marker)))
                 (with-current-buffer (marker-buffer source-marker)
                   (goto-char source-position)
                   (org-entry-delete (point) "ID")
                   (org-demote)
                   (let ((current-parent-ids
                          (org-entry-get (point) "PARENT_ID")))
                     (org-paste-subtree 1)
                     (when current-parent-ids
                       (org-entry-put (point) "PARENT_ID"
                                      current-parent-ids)))
                   (org-entry-put (point) "ID" source-id)
                   (org-entry-delete (point) "SOURCE_ID")
                   (when parent-id
                     (org-entry-add-to-multivalued-property
                      source-position "PARENT_ID" parent-id)))))
           (let (id)
             (with-current-buffer db-buffer
               (goto-char (point-max))
               (org-paste-subtree 1)
               (setq id (org-id-get-create))
               (when parent-id
                 (org-entry-put (point) "PARENT_ID" parent-id)))
             (org-entry-put (point) "SOURCE_ID" id)))))
     (point-min) (point-max))))

(provide 'org-db)

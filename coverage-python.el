(defun coverage-python-json (coverage-file)
  "Return json coverage for the file COVERAGE-FILE"
  (let* ((json-object-type 'hash-table)
         (json-array-type 'list)
         (json-key-type 'string)
         (json (json-read-file coverage-file)))
    json
    ))

(defun coverage-vc-git-target-file (target-path)
  (string-remove-prefix (expand-file-name (vc-git-root target-path)) target-path))


(defun coverage-get-results-for-python-file (target-path coverage-json)
  "Return coverage for the file at TARGET-PATH"
  (let* ((coverage (gethash (coverage-vc-git-target-file target-path)
                            (gethash "files" coverage-json)))
         (executed-lines (gethash "executed_lines" coverage))
         (missing-lines (gethash "missing_lines" coverage))
         (coverage-lines (make-list (count-lines (point-min)
                                                 (buffer-size))
                                    'nil)))
    (dolist (item executed-lines)
      (setf (nth (- item 1) coverage-lines) 1))
    (dolist (item missing-lines)
      (setf (nth (- item 1) coverage-lines) 0))
    coverage-lines
    )
  )

(provide 'coverage-python)

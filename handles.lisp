(in-package :spider)

(defun scan-file-line (rule file-name)
  (let ((results nil)) 
    (with-open-file (in file-name)
      (with-standard-io-syntax
        (when in
          (loop for line = (read-line in nil)
                while line do (let ((temp (cl-ppcre:scan-to-strings rule line)))
                                (if temp
                                    (setf results (append results (list temp)))))))))
    results))

(defun scan-file-all (rule file-name)
  (let ((all ""))
    (with-open-file (in file-name)
      (with-standard-io-syntax
        (when in
          (loop for line = (read-line in nil)
                while line do (setf all (format nil "~A~A" all line))))))
    (cl-ppcre:scan-to-strings rule all)))

(defun last-index (file-name)
  (parse-integer (cl-ppcre:scan-to-strings "[0-9]{3}" (car (scan-file-line "blog.reimu.net\/page\/[0-9]{3}\">尾页" (namestring file-name))))))

(defun page-name (i)
  (make-pathname :name (format nil "page~A" i) :type "html"))

(defun download-page (i base-host)
  (run-shell (format nil "cd ~A;proxychains wget -O ~A ~A" 
                     (namestring (get-save-path)) 
                     (namestring (page-name i)) 
                     (format nil "~A/page/~A" base-host i))))

(defun get-postid (i)
  (mapcar #'(lambda (str)
             (cl-ppcre:scan-to-strings "[0-9]+" str))
          (scan-file-line "<article id=\"post-[0-9]*\"" (merge-pathnames (page-name i) (get-save-path)))))

(defun get-link (i)
  (scan-file-line "https://blog.reimu.net/archives/[0-9]*#more-[0-9]*" (merge-pathnames (page-name i ) (get-save-path))))

(defun get-date (i)
  (mapcar #'(lambda (str)
              (cl-ppcre:scan-to-strings "[0-9]{4}-[0-9]{2}-[0-9]{2}" str))
          (scan-file-line "published.*[0-9]{4}-[0-9]{2}-[0-9]{2}<\/time><time class=\"updated\"" (merge-pathnames (page-name i) (get-save-path)))))

(defmethod lingmeng-handle ((task-one task))
  (format t "~A~%" (task-id task-one))
  (download-page ((page-name 1) (get-base-host task-one)))
  (if (probe-file (page-name 1))
      (format t "Finish"))
  (do* ((i 1 (+ 1 i)))
    ((> i (last-index page)) 'done)
    (when (not (= i 1))
      (download-page i (get-base-host task-one)))
    ;TODO get the last date source and remove the before sourcel; then enter the source page get the link and the info
    ()
    ))

(in-package :cl-user)

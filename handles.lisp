(in-package :spider)

(defun map-file-line (file-name fun)
  (if (functionp fun)
      (let ((temp nil)) 
        (with-open-file (in file-name)
          (with-standard-io-syntax
            (when in
              (loop for line = (read-line in nil)
                    while line do (setf temp (append (list (funcall fun line))))))))
        temp)))

(defun scan-file-line (rule file-name)
  (let ((results nil)) 
    (map-file-line file-name #'(lambda (line)
                                 (let ((temp (cl-ppcre:scan-to-strings rule line)))
                                   (if temp
                                       (setf results (append results (list temp)))))))
    results))

(defun scan-file-all (rule file-name)
  (let ((all ""))
    (map-file-line file-name #'(lambda (line)
                                 (setf all (format nil "~A~A" all line))))
    (cl-ppcre:scan-to-strings rule all)))

(defun last-index (file-name)
  (parse-integer (cl-ppcre:scan-to-strings "[0-9]{3}" (car (scan-file-line "blog.reimu.net\/page\/[0-9]{3}\">尾页" (namestring file-name))))))

(defun make-name (name i &optional (file-type "html"))
  (make-pathname :name (format nil "~A~A" name i) :type file-type))

(defun append-dir (path dir)
  (if (and (not (pathname-name path)) (stringp dir)) 
      (make-pathname :directory (format nil "~A~A" (namestring path) dir))))

(defun download-page (i base-host)
  (run-shell (format nil "cd ~A;proxychains wget -O ~A ~A" 
                     (namestring (append-dir (get-save-path) "pages")) 
                     (namestring (make-name "page" i)) 
                     (format nil "~A/page/~A" base-host i))))

(defun download-archive (postid base-host)
  (run-shell (format nil "cd ~A/archives;proxychains wget -O ~A ~A" 
                     (namestring (append-dir (get-save-path) "archives")) 
                     (namestring (make-name "archive" postid)) 
                     (format nil "~A/archives/~A#more-~A" base-host postid postid))))

(defun get-postid (i)
  (mapcar #'(lambda (str)
             (cl-ppcre:scan-to-strings "[0-9]+" str))
          (scan-file-line "<article id=\"post-[0-9]*\"" (merge-pathnames (make-name "page" i) (append-dir (get-save-path) "pages")))))

(defun get-date (i)
  (mapcar #'(lambda (str)
              (cl-ppcre:scan-to-strings "[0-9]{4}-[0-9]{2}-[0-9]{2}" str))
          (scan-file-line "published.*[0-9]{4}-[0-9]{2}-[0-9]{2}<\/time><time class=\"updated\"" (merge-pathnames (make-name "page" i) (append-dir (get-save-path) "pages")))))

(defun save-archives (archives)
  (let ((path (merge-pathnames (make-pathname :name "archives" :type "txt") (append-dir (get-save-path) "archives"))))
    (save-file archives (namestring path))))

(defun load-archives ()
  (let ((path (merge-pathnames (make-pathname :name "archives" :type "txt") (append-dir (get-save-path) "archives")))) 
    (if (probe-file path)
        (load-file (namestring path)))))

(defun append-rs (f-lst lst &key (key #'(lambda (x) x)) (test #'eql))
  (dolist (i lst)
    (setf lst (remove (funcall key (find (funcall key i) f-lst :key key :test test)) lst :key key :test test)))
  (append f-lst lst))

(defun make-source (postid)
  ;TODO
  )

(defmethod lingmeng-handle ((task-one task))
  (format t "~A~%" (task-id task-one))
  (download-page 1 (get-base-host task-one))
  (if (probe-file (namestring (merge-pathnames (make-name "page" 1) (append-dir (get-save-path) "pages"))))
      (progn (format t "Finish~%")
             (do* ((i 1 (+ 1 i)))
               ;TODO need hava last date ;then can don't download the last archive
               ((> i (last-index (merge-pathnames (make-name "page" 1) (append-dir (get-save-path) "pages")))) 'done)
               (when (not (= i 1))
                 (download-page i (get-base-host task-one))
                 (format t "download page:~A~%" i))
               (let ((archives (mapcar #'(lambda (id date)
                                           (list id date))
                                       (get-postid i)
                                       (get-date i))))
                 (save-archives (append-rs (load-archives) archives :key #'car :test #'string=)))))
      (format t "ERROR")))

(in-package :cl-user)

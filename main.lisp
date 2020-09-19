(in-package :spider)

(defparameter *run-task-list* (make-array 5 :fill-pointer 0 :adjustable t) "The Run task List")
(setf (gethash "lingmeng" (get-handle-fun)) #'lingmeng-handle)

(defun show-list ()
  (doTimes (i (length *run-task-list*))
    (format t "[~a]:Start~%" (+ i 1))
    (show-task (elt *run-task-list* i))
    (format t "[~a]:End~%" (+ i 1))))

(defun find-task (id)
  (find id *run-task-list* :key #'task-id :test #'string=))

;;;About task some operating
(defun add-task (id base-host handle-fun &optional (proxyp t))
  (if (and (stringp handle-fun) (gethash handle-fun (get-handle-fun)))
      (let ((task-one (make-instance 'task :id id :base-host base-host :proxyp proxyp :handle-fun handle-fun)))
        (vector-push task-one *run-task-list*)
        (start-task task-one))
      (progn (format t "The handle-fun must be a in-list-string~%")
             (format t "The list is:~%")
             (maphash #'(lambda (k v)
                          (format t "~A~%" k)) (get-handle-fun))
             (format t "END~%")
             nil)))

(defun remove-task (id)
  (stop-task (find-task id))
  (setf *run-task-list* (remove id *run-task-list* :key #'task-id :test #'string=)))

(defun save-list (path)
  (let ((path-list ()) 
        (taskpath (pathname (format nil "~Atask/" path))))
    (ensure-directories-exist taskpath)
    (format t "test~%")
    (doTimes (i (length *run-task-list*))
             (format t "task:~A~%" (task-id (elt *run-task-list* i)))
             (push (save-task (elt *run-task-list* i) taskpath) path-list))
    (dolist (i path-list)
      (format t "~A~%" i))
    (save-file path-list (merge-pathnames (make-pathname :name "files" :type "txt") 
                                          (pathname path)))))

(defun load-list (path)
  (let ((path-list (load-file (merge-pathnames (make-pathname :name "files" :type "txt") 
                                               (pathname path)))))
    (dolist (i path-list)
             (let ((task-one (load-task i))) 
               (vector-push task-one *run-task-list*)
               (start-task task-one)))))

(defun test-task ()
  (add-task "lingmeng" "https://blog.reimu.net" "lingmeng"))

(in-package :cl-user)

(in-package :spider)

(defparameter *run-task-list* (make-array 5 :fill-pointer 0 :adjustable t) "The Run task List")

(defun show-list ()
  (doTimes (i (length *run-task-list*))
    (format t "[~a]:Start~%" (+ i 1))
    (show-task (elt *run-task-list* i))
    (format t "[~a]:End~%" (+ i 1))))

(defun find-task (id)
  (find id *run-task-list* :key #'task-id :test #'string=))

;;;About task some operating
(defun add-task (id base-host handle-fun &optional (proxyp t))
  (let ((task-one (make-instance 'task :id id :base-host base-host :proxyp proxyp :handle-fun handle-fun)))
    (vector-push task-one *run-task-list*)
    (start-task task-one)))

(defun remove-task (id)
  (setf *run-task-list* (remove id *run-task-list* :key #'task-id :test #'string=)))

(defun save-list (save-path)
  (let ((path-list ()))
    (doTimes (i (- (length *run-task-list*) 1))
             ;TODO this must add a directory
             (append path-list (list (save-task (elt *run-task-list* i)
                                                (pathname (format nil "~A~A/" save-path "task"))))))
    (save-file path-list (merge-pathnames (make-pathname :name "files" :type "txt") 
                                          (pathname save-path)))))

(defun load-list (load-path)
  (let ((path-list (load-file (merge-pathnames (make-pathname :name "files" :type "txt") 
                                               (pathname save-path)))))
    (doTimes (i (- (length *run-task-list*) 1))
             (let ((task-one (load-task i))) 
               (vector-push task-one *run-task-list*)
               (start-task task-one)))))

(in-package :cl-user)

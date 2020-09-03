(in-package :spider)

(defgeneric get-resources (task-one) 
  (:documentation "get the url"))

(defgeneric run-task (task-one) 
  (:documentation "run the task to the long"))

(defgeneric start-task (task-one)
  (:documentation "start-task thread"))

(defgeneric handle (task-one) 
  (:documentation "handle the page"))

(defgeneric show-task (task-one)
  (:documentation "show task base info"))

(defgeneric become-plist (task-one)
  (:documentation "become a plist"))

(defgeneric save-task (task-one save-path)
  (:documentation "save the task"))

(defun load-task (load-path)
  (let ((plist-t (load-file (merge-pathnames :name "task" :type "txt") load-path)))
    (make-instance 'task :id (getf plist-t :id) :base-host (getf plist-t :base-host)
                   :proxyp (getf plist-t :proxyp) :resources (getf plist-t :resources)
                   :handle-fun (getf plist-t :handle-fun) :last-date (getf plist-t :last-date)
                   :runp (getf plist-t :runp) :nowrunp (getf plist-t :nowrunp))))

(defun get-thread-name ()
  (thread-name (current-thread)))

;download-url (:baiduyun-share (url ma) :baiduyun-ma url :mega url :bt-url url :bt-file path :common-url url)
;((:id id :download-url download-url :zip-code "nil" :web-url web-url :info info) () ())
(defclass task () 
  ((id
     :initarg :id
     :initform (error "Must supply a task id")
     :accessor task-id) 
   (base-host
     :initarg :base-host
     :initform (error "Must supply a task host")
     :accessor get-base-host)
   (proxyp
     :initarg :proxyp
     :initform nil
     :accessor isproxyp)
   (resources
     :initarg :resources
     :initform nil
     :accessor task-resources) 
   (handle-fun
     :initarg :handle-fun
     :initform (error "Must supply a task handle-fun")
     :accessor get-handle)
   (last-date
     :initform (now)
     :accessor last-date) 
   (runp
     :initform t
     :accessor get-run) 
   (nowrunp
     :initform t
     :accessor get-now-run)))

;;sources (id ((baiduyun-url tiquma) biaozhongma mega) jieyama web-url info)
(defmethod get-resources ((task-one task))
  (task-resources task-one))

(defmethod run-task ((task-one task)) 
  (do () ((not (get-run task-one)) 'done) 
      (setf (get-now-run task-one) t) 
      (format t "RUn:thread name:~A~%" (get-thread-name))
      (apply (get-handle task-one) (list task-one))
      (setf (get-now-run task-one) nil) 
      (do ((i 1 (+ i 1))) 
          ((and (not (get-now-run task-one)) (< i 1800)) 'done) 
          (sleep 1))))

(defmethod start-task ((task-one task))
  (make-thread (lambda () (run-task task-one)) :name (task-id task-one)))

(defmethod show-task ((task-one task))
  (format t "id:~A~%url:~A~%"
          (task-id task-one)
          (get-base-host task-one)))

(defmethod become-plist ((task-one task))
  (list :id (task-id task-one) :base-host (get-base-host task-one) :proxyp (isproxyp task-one) 
        :resources (task-resources task-one) :handle-fun (get-handle task-one) 
        :last-date (last-date task-one) :runp (get-run task-one) :nowrunp (get-now-run task-one)))

(defmethod save-task ((task-one task) save-path) 
  (save-file (become-plist task-one)
             (merge-pathnames (make-pathname :name "task" :type "txt") save-path)))


(in-package :cl-user)

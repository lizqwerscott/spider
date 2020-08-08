(in-package :spider)

(defgeneric get-url ((task-one task) url) 
  (:documentation "get the url"))

(defgeneric run ((task-one task)) 
  (:documentation "run the task to the long"))

(defgeneric handle ((task-one task)) 
  (:documentation "handle the page"))


(defclass task () 
  ((id
     :initarg :id
     :initform (error "Must supply a task id")
     :accessor task-id) 
   (base-host
     :initarg :base-host
     :initform (error "Must supply a task host")
     :accessor get-base-host) 
   (max-deep
     :initarg :max-deep
     :initform 5
     :accessor get-max-deep) 
   (max-height 
     :initarg :max-height
     :initform 50
     :accessor get-max-height)
   (sources
     :initarg :sources
     :initform nil
     :accessor get-sources) 
   (last-date
     :initform (now)
     :accessor last-date) 
   (runp
     :initform t
     :accessor get-run) 
   (nowrunp
     :initform t
     :accessor get-now-run) 
   (root
     :initform nil
     :accessor get-root)))

(defmethod initialize-instance :after ((task-one task) &key) 
  (setf (get-root task-one) 
        (make-instance 'node 
                       :now-host (get-base-host task-one)
                       :handle-fun (lambda () 
                                     ()))))

(defmethod run ((task-one task)) 
  (do () ((not (get-run task-one)) 'done) 
      (setf (get-now-run task-one) t) 
      ();;TODO
      (setf (get-now-run task-one) nil) 
      (do ((i 1 (+ i 1))) 
          ((and (not (get-now-run task-one)) (< i 1800)) 'done) 
          (sleep 1))))

(in-package :cl-user)


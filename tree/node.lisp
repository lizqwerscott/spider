(in-package :tree)

(defgeneric run-node ((node-one node)))

(defclass node () 
  ((parents
     :initarg :parents
     :initform nil
     :accessor get-parents) 
   (childens 
     :initform nil 
     :accessor get-childens) 
   (now-host
     :initarg :now-host
     :initform (error "Must supply a host")
     :accessor get-host) 
   (handle-fun
     :initarg :handle-fun
     :initform (error "Must supply a handle-function")
     :accessor get-handle)))

(defmethod run-node ((node-one node)) 
  (get-handle node-one) 
  (dolist (i (get-childens node-one)) 
    (run-node i)));TODO

(in-package :cl-user)

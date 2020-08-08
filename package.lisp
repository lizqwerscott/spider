(in-package :cl-user)

(defpackage :tree 
  (:use :common-lisp :uiop :dexador :cl-json) 
  (:export :tree
           :node))

(defpackage :spider 
  (:use :common-lisp :uiop :dexador :cl-json :local-time :chronicity :tree) 
  (:export ))

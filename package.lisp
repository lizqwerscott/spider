(in-package :cl-user)

(defpackage :spider.head
  (:use :common-lisp)
  (:export 
    :save-file
    :load-file))

(defpackage :spider 
  (:use :common-lisp :spider.head :bordeaux-threads :local-time :cl-json) 
  (:export 
    :get-resources
    :start-task
    :show-task
    :save-task
    :load-task
    :add-task
    :remove-task
    :find-task
    :show-list
    :save-list
    :load-list))

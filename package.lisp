(in-package :cl-user)

(defpackage :spider.head
  (:use :common-lisp :uiop)
  (:export 
    :save-file
    :load-file
    :run-shell
    :get-save-path
    :set-save-path))

(defpackage :spider 
  (:use :common-lisp :spider.head :bordeaux-threads :local-time :cl-json) 
  (:export 
    :get-handle-fun
    :get-resources
    :start-task
    :stop-task
    :show-task
    :save-task
    :load-task
    :add-task
    :remove-task
    :find-task
    :show-list
    :save-list
    :load-list
    :test-task))

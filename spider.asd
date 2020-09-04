(defsystem "spider" 
  :version "0.0.0"
  :author "lizqwer scott"
  :license "GPL"
  :description "a spider"
  :depends-on ("uiop"
               ;;threads
               bordeaux-threads
               ;; json
               "cl-json"
               ;; web
               "dexador"
               ;; time
               "local-time"
               ;;chronicity
               )
  :components ((:file "package")
               (:file "head" :depends-on ("package"))
               (:file "task" :depends-on ("package" "head"))
               (:file "handles" :depends-on ("package" "head" "task"))
               (:file "main" :depends-on ("package" "head" "task" "handles"))))

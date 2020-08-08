(defsystem "spider" 
  :version "0.0.0"
  :author "lizqwer scott"
  :license "GPL"
  :depends-on ("uiop"
               ;; json
               "cl-json"
               ;; web
               "dexador"
               ;; time
               "local-time"
               "chronicity")
  :components ((:file "package")
               (:module "tree"
                :depends-on ("package")
                :serial t
                :components ((:file "node") 
                             (:file "tree" :depends-on ("node"))))
               (:file "main" :depends-on ("package" "tree")))
  :description "a spider")



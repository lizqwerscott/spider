(in-package :spider)

(defmethod lingmeng-handle ((task-one task))
  (format t "~A~%" (task-id task-one)))

(in-package :cl-user)

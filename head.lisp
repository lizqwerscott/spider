(in-package :spider.head)

(defun save-file (data file)
  (with-open-file (out file :direction :output :if-exists :supersede) 
    (with-standard-io-syntax 
      (print data out))) file)

(defun load-file (path)
  (with-open-file (in path)
    (with-standard-io-syntax
      (read in))))

(in-package :cl-user)

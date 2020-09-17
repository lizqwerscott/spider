(in-package :spider.head)

(defparameter *save-place* (pathname "/home/lizqwer/temp/spider/download/"))

(defun get-save-path ()
  *save-place*)

(defun set-save-path (path)
  (setf *save-place* path))

(defun save-file (data file)
  (with-open-file (out file :direction :output :if-exists :supersede) 
    (with-standard-io-syntax 
      (print data out))) file)

(defun load-file (path)
  (with-open-file (in path)
    (with-standard-io-syntax
      (read in))))

(defun run-program-m (program parameter &key (input nil) (output nil))
  #+sbcl (sb-ext:run-program (uiop:unix-namestring program) parameter :input input :output output)
  #+clozure (ccl:run-program (uiop:unix-namestring program) parameter :input input :output output))

(defun run-shell (cmd &optional (isDebug-p nil))
  (if isDebug-p 
      (let ((stream1 (make-string-output-stream))) 
        (run-program-m #P"/bin/sh" (list "-c" cmd) :input nil :output stream1)
        (get-output-stream-string stream1))
      (run-program-m #P"/bin/sh" (list "-c" cmd) :input nil :output nil)))

(in-package :cl-user)

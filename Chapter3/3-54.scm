(load "3.5.2.scm")

(define factorials 
  (cons-stream 1 (mul-streams factorials
			      (integers-starting-from 2))))

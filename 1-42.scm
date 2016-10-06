(load "basic.scm")

(define (compose f g)
	(lambda (x) (f (g x))))
(load "basic.scm")

(define (double f)
	(lambda (x) (f (f x))))

(define (3d-inc x)
	(((double (double double)) inc) x)) 

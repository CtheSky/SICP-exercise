(load "1.3.4.scm")

(define (cubic a b c)
	(lambda (x) (+ (cub x)
				   (* a (square x))
				   (* b x)
				   c)))
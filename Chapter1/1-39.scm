(load "1-37.scm")

(define (square x) (* x x))
(define (tan-cf x k)
	(define (n k)
		(if (zero? k)
			x
			(* -1 (square x))))
	(define (d k)(+ 1 (* 2 k)))
	(cont-frac-iter n d k))
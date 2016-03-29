(load "c:\\scheme\\ex\\1-37.scm")

(define (n k) 1.0)
(define (d k)
	(if (= 2 (remainder k 3))
		(+ 2 (* 2 (/ (- k 2) 3)))
		1.0))

(define e (+ 2(cont-frac-iter n d 100000)))
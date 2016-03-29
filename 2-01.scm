(load "c:\\scheme\\ex\\basic.scm")

(define (make-rat x y) 
	(let ((g (gcd x y)))
		(cons (/ x g) (/ y g))))
(define (number x) (car x))
(define (denom x) (cdr x))
(load "2-56.scm")

(define (sum? x)
	(and (pair? x) (eq? '+ (car x))))
(define (addend s) (cadr s))
(define (augend s) 
	(if (null? (cdddr s))
		(caddr s)
		(cons '+ (cddr s))))
(define (product? x)
	(and (pair? x) (eq? '* (car x))))
(define (multiplier p) (cadr p))
(define (multiplicand p)
	(if (null? (cdddr s))
		(caddr s)
		(cons '* (cddr s))))
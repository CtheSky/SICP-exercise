;;into integer package
(define (integer->rational i)
	(make-rational i 1))

(put 'raise '(integer)
	(lambda (i) (integer-rational i)))
	
;;into rational package
(define (rational->real r)
	(make-real
		(exact->inexact
			(/ (numer r) (denom r)))))
			
(put 'raise '(rational)
	(lambda (r) (rational->real r)))
	
;;into real package
(define (real->complex r)
	(make-complex-from-real-image r 0))

(put 'raise '(real)
	(lambda (r) (real->complex r)))
	
(define (raise x)
	(apply-generic 'raise x))

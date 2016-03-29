(define (cons x y)
	(lambda (n)
		(cond ((= 0 n) x)
			  ((= 1 n) y)
			  (else (error "Argument not 0 or 1 -- cons" n)))))
			  
(define (car z) (z 0))
(define (cdr z) (z 1))
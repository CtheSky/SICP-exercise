(define (equal? a b)
	(cond ((or (null? a) (null? b)) (eq? a b))
		  ((eq? (car a) (car b)) (equal? (cdr a) (cdr b)))
		  (else #f)))
(define (reverse items)
	(define (iter items ret)
		(if (null? items)
			ret
			(iter (cdr items) 
			      (cons (car items) ret))))
	(iter items ()))
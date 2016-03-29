(define (deep-reverse x)
	(cond ((not (pair? x)) x)
		  ((null? (cdr x)) (car x))
		  (else (append (list (deep-reverse (cdr x))) 
					    (list (deep-reverse (car x)))))))
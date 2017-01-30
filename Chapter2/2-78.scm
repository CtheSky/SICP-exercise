(load "2.5.1.scm")
(define (attach-tag type-tag contents)
	(if (number? contents)
		(cons 'scheme-number contents)
		(cons type-tag contents)))
(define (type-tag datum)
	(cond ((number? datum) 'scheme-number)
		  ((pair? datum) (car datum))
		  (else	 
			 (error "Bad tagged datum -- TYPE-TAG" datum))))
(define (contents datum)
	(cond ((number? datum) datum)
		  ((pair? datum) (cadr datum))
		  (else
			(error "Bad tagged datum -- CONTENTS" datum))))
;;into polynomial package
(define (zero-poly? p)
	(let ((terms (term-list p)))
		(if (empty-termlist? terms)
			#t
			(and (=zero? (coeff (first-term terms)))
				 (zero-poly? 
					(make-poly (variable p)
							   (rest-terms terms)))))))

(put '=zero? 'polynomial
	(lambda (p) (zero-poly? p)))
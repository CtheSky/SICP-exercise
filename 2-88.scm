(define (neg x) (apply-generic 'neg x))

;;into polynomial package
(define (negate-terms terms)
	(if (empty-termlist? terms)
		(the-empty-termlist)
		(let ((first (first-term terms)))
			(adjion-term (make-term (order first)
									(neg (coeff first)))
						 (negate-terms (rest-terms terms))))))

(define (negate-poly p)
	(make-poly (variable p)
			   (negate-terms (termlist p))))

(define (sub-poly p1 p2)
	(add-poly p1 (negate-poly p2)))

(put 'sub '(polynomial polynomial)
	(lambda (p1 p2) (sub-poly p1 p2)))
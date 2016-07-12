;;use +, halve, double to impelement *
(define (* a b)
  (define (iter a b n)
    (cond ((= b 0) n)
	  ((even? b) (iter (double a) (halve b) n))
	  (else
	   (iter a (- b 1) (+ n a)))))
  (iter a b 0))

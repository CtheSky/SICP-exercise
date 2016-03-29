(define (Simpson-Integral f a b n)
	(define (integral-iter a b count post)
		(cond ((> count n) post)
		      ((or(= count 0) (= count n)) (integral-iter a b (+ 1 count) (+ post (f a))))
			  ((even? count) (integral-iter a 
										    b 
											(+ 1 count) 
											(+ post (* 4 (f (+ a (* count (/ (- b a) n))))))))
			  (else (integral-iter a 
								   b 
								   (+ 1 count) 
								   (+ post (* 2 (f (+ a (* count (/ (- b a) n))))))))))
	(* (/ (- b a) n)
	   (integral-iter a b 0 0.0)
	   (/ 1.0 3)))
			  
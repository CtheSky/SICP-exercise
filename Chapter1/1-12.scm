(define (f i j)
  (cond ((< i j) (error "wrong input"))
	((or (= j 1) (= j i)) 1)
	(else (+ (f (- i 1) (- j 1))
		 (f (- i 1) j)))))
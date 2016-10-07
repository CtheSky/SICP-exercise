;;linear recursion 
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
	 (* 2 (f (- n 2)))
	 (* 3 (f (- n 3))))))

;;linear iteration 
(define (g n)
  (define (iter a b c n)
    (if (= n 0)
	a
	(iter b
	      c
	      (+ c (* 2 b) (* 3 a))
	      (- n 1))))
  (iter 0 1 2 n))

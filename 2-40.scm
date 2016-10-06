(load "2.2.3.scm")

(define (unique-pairs n)
	(flatmap (lambda (i)
				(map (lambda (j) (list j i))
					(enumerate-interval 1 (- i 1))))
			 (enumerate-interval 2 n)))
			 
(define (prime-sum-pairs n)
	(map make-pair-sum 
		(filter prime-sum?
				(unique-pairs n))))
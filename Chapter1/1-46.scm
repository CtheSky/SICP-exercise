(define (interative-improve check improve)
	(define (iter guess)
		(let ((next (improve guess)))
			(if (check next guess) 
				next
				(iter next))))
	iter)
	
(define tolerance 0.00000000001)
(define (close-enough? x y) (> tolerance (abs (- x y))))

(define (fixed-point f guess)
	((interative-improve close-enough? f) guess))
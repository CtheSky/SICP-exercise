(define tolerance 0.00001)
(define (close-enough? x y) (> tolerance (abs (- x y))))

(define (fixed-point f first-guess)
	(define (try guess)
		(newline)
		(display guess)
		(let ((next (f guess)))
			(if (close-enough? guess next)
				guess
				(try next))))
	(try first-guess))

(define (fixed-point-average-damping f first-guess)
	(define (try guess)
		(newline)
		(display guess)
		(let ((next (/ (+ guess(f guess)) 2)))
			(if (close-enough? guess next)
				guess
				(try next))))
	(try first-guess))
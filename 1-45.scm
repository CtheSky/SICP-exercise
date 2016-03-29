(load "c:\\scheme\\ex\\1.3.4.scm")
(load "c:\\scheme\\ex\\1-43.scm")

(define (fixed-point-check-convergence f first-guess)
	(define (try guess count)
		(let ((next (f guess)))
			(cond ((> count 1000) "Not convergent after 1000 try.")
			      ((close-enough? guess next) guess)
				  (else (try next (+ 1 count))))))
	(try first-guess 0))
	
(define (check f n guess)
	(fixed-point-check-convergence ((repeated average-damp n) f) guess))


(load "c:\\scheme\\ex\\1-42.scm")

(define (repeated f n)
	(define (iter g count)
		(if (= 1 count)
			g
			(iter (compose f g) (- count 1))))
	(iter f n))
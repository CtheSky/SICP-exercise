(load "c:\\scheme\\ex\\2-08.scm")

(define (div-interval x y)
	(let ((u-y (upper-bound y))
		  (l-y (lower-bound y)))
		(if (> 0 (* u-y l-y))
			(error "Divide Interval crossing 0 point, interval agruments:" l-y u-y)
			(mul-interval x
						  (make-interval (/ 1.0 u-y)
										 (/ 1.0 l-y))))))
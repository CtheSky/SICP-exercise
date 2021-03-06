(load "2-10.scm")

(define (mul-interval x y)
	(let ((u1 (upper-bound x))
		  (l1 (lower-bound x))
		  (u2 (upper-bound y))
		  (l2 (upper-bound y)))
		 (cond ((and (>= u1 0) (>= l1 0) (>= u2 0) (>= l2 0))
					(make-interval (* l1 l2) (* u1 u2)))
			   ((and (>= u1 0) (>= l1 0) (>= u2 0) (<= l2 0))
					(make-interval (* u1 l2) (* u1 u2)))
			   ((and (>= u1 0) (>= l1 0) (<= u2 0) (<= l2 0))
					(make-interval (* l1 u2) (* u1 l2)))
			   ((and (>= u1 0) (<= l1 0) (>= u2 0) (>= l2 0))
					(make-interval (* l1 u2) (* u1 u2)))
			   ((and (>= u1 0) (<= l1 0) (>= u2 0) (<= l2 0))
					(make-interval (min (* u1 l2) (* u2 la)) (* u1 u2)))
			   ((and (>= u1 0) (<= l1 0) (<= u2 0) (<= l2 0))
					(make-interval (* u1 l2) (* l1 l2)))
			   ((and (<= u1 0) (<= l1 0) (>= u2 0) (>= l2 0))
					(make-interval (* l1 u2) (* u1 l2)))
			   ((and (<= u1 0) (<= l1 0) (>= u2 0) (<= l2 0))
					(make-interval (* l1 u2) (* u1 l2)))
			   ((and (<= u1 0) (<= l1 0) (<= u2 0) (<= l2 0))
					(make-interval (* u1 u2) (* l1 l2)))
			   (else (error "wrong interval input" x y)))))
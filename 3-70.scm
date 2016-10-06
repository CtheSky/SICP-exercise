(load "3.5.3.scm")

(define (weighted-pairs s t weight)
  (cons-stream (list (stream-car s) (stream-car t))
	       (merge-weighted (stream-map (lambda (x) (list (stream-car s) x))
					   (stream-cdr t))
			       (weighted-pairs (stream-cdr s)
					       (stream-cdr t)
					       weight)
			       weight)))
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
	((stream-null? s2) s1)
	(else
	 (let ((s1-car (stream-car s1))
	       (s2-car (stream-car s2)))
	   (if (< (weight s1-car)
		  (weight s2-car))
	       (cons-stream s1-car
			    (merge-weighted (stream-cdr s1) s2 weight))
	       (cons-stream s2-car 
			    (merge-weighted s1 (stream-cdr s2) weight)))))))

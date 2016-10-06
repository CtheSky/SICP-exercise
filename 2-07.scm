(load "2.1.4.scm")

(define (make-interval a b) (cons a b))
(define (upper-bound interval) 
	(cdr interval))
(define (lower-bound interval)
	(car interval))
(load "c:\\scheme\\ex\\2-10.scm")

(define (make-center-percent c p)
	(let ((w (* c (abs p))))
		(make-interval (- c w) (+ c w))))
		
(define (center i)
	(/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
	(/ (- (upper-bound i) (lower-bound i)) 2))
	
(define (percent i)
	(abs (/ (width i) (center i))))
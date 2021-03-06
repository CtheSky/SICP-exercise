(load "1.3.3.scm")
(load "basic.scm")

(define (average-damp f)
	(lambda (x) (average x (f x))))

(define (sqrt x)
	(fixed-point (average-damp (lambda (y) (/ x y))) 
				 1.0))
				 
(define (cube-root x)
	(fixed-point (average-damp (lambda (y) (/ x (square y)))) 
				 1.0))
				 
(define (deriv g)
	(define dx 0.00001)
	(lambda (x) (/ (- (g (+ x dx)) (g x))
				   dx)))

(define (newton-transform g)
	(lambda (x) (- x (/ (g x)((deriv g) x)))))
	
(define (newton-method g guess)
	(fixed-point (newton-transform g) guess))
	
(define (sqrt-2 x)
	(newton-method (lambda (y) (- (square y) x)) 1.0))
	
	
(define (fixed-point-of-transform g transform guess)
	(fixed-point (transform g) guess))

(define (sqrt# x)
	(fixed-point-of-transform (lambda (y) (/ x y))
							  average-damp
							  1.0))
(define (sqrt#-2 x)
	(fixed-point-of-transform (lambda (y) (- (square y) x))
							  newton-transform
							  1.0))
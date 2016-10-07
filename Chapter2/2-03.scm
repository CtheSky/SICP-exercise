(load "2-02.scm")

(define (make-rectangle x1 x2 y1 y2)
	(cons (make-point x1 y1) (make-point x2 y2)))
(define (height-rectangle rect)
	(abs (- (y-point (car rect)) (y-point (cdr rect)))))
(define (width-rectangle rect)
	(abs (- (x-point (car rect)) (x-point (cdr rect)))))
	
	
(define (perimeter rect)
	(* 2 (+ (height-rectangle rect) (width-rectangle rect))))
(define (area rect)
	(* (height-rectangle rect) (width-rectangle rect)))
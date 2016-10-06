(load "3.1.2.scm")
(load "basic.scm")

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (rect x1 x2 y1 y2)
  (abs (* (- x1 x2) (- y1 y2))))

(define (estimate-integral p x1 x2 y1 y2 trials)
  (let ((integral-test 
	 (lambda ()
	   (p (random-in-range x1 x2)
	      (random-in-range y1 y2)))))
    (* (rect x1 x2 y1 y2)
       (monte-carlo trials integral-test))))

(define (inside-unit-circle? x y)
  (>= 1 
      (+ (square x) (square y))))

(define (estimate-pi)
  (estimate-integral inside-unit-circle? -1.0 1.0 -1.0 1.0 10000))

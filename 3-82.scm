(load "c:\\scheme\\ex\\3.5.5.scm")

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (inside-unit-circle? x y)
  (>= 1 
      (+ (square x) (square y))))

(define integral-test
  (lambda ()
    (inside-unit-circle? (random-in-range -1.0 1.0)
			 (random-in-range -1.0 1.0))))

(define estimate-integral-stream
  (cons-stream (integral-test)
	       estimate-integral))

(define estimate-pi
  (stream-map (lambda (p) (* p 4))
	      (monte-carlo estimate-integral-stream 0 0)))

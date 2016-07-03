(define tolerance 0.0001)
(define (average x y) (/ (+ x y) 2))
(define (abs x) (if (>= x 0) x (* -1 x)))


(define (sqrt n)
  (define (sqrt-iter guess)
    (if (good-enough? guess)
	guess
	(sqrt-iter (improve guess))))
  (define (improve guess)
    (average guess (/ n guess)))
  (define (good-enough? guess)
    (> tolerance
       (abs (/ (- n (* guess guess)) n))))
  (sqrt-iter 1.0))

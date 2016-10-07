(define (random-update x)
  (let ((a 27) (b 26) (m 127))
    (modulo (+ (* a x) b) m)))

(define random-init
  (random-update (expt 2 32)))

(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (random-update x))
      x)))

(define (estimate-pi trials)
  (sqrt (/ 6 (mote-cario trials cesaro-test))))

(define (cesaro-test)
  (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter remained passed)
    (cond ((= remained 0)
	   (/ passed trials))
	  ((experiment)
	   (iter (- remained 1) (+ passed 1)))
	  (else
	   (iter (- remained 1) passed))))
  (iter trials 0))

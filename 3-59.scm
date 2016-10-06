(load "3.5.2.scm")

(define (integrate-series argu-stream)
  (mul-streams argu-stream
	       (stream-map (lambda (x) (/ 1 x))
			   integers)))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (integrate-series (stream-map (lambda (x) (* -1 x)) 
					       sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

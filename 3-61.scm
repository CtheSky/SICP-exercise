(load "c:\\scheme\\ex\\3-60.scm")

(define (invert-after1-series s)
  (cons-stream 1
	       (scale-stream
		(mul-series (stream-cdr s)
			    (invert-after1-series s))
		-1)))

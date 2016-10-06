(load "3-61.scm")

(define (div-series num denom)
  (let ((denom-const (stream-car denom)))
    (if (= 0 denom-const)
	(error "Denom constant is zero -- DIV-SERIES")
	(mul-series 
	 (invert-after1-series
	  (scale-stream denom denom-const))
	 num))))

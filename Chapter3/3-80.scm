(define (RLC R L C dt)
  (lambda (vc0 il0)
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (scale-stream il0 (/ -1 C)))
    (define dil (add-streams
		 (scale-stream vc (/ 1.0 L))
		 (scale-stream il (/ (* -1 R) L))))
    (cons vc il)))

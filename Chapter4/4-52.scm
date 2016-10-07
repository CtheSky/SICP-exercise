;;if-fall
(define (if-fall? exp) (tagged-list? exp 'if-fall))

(define (analyze-if-fall exp)
  (let ((pproc (analyze (if-predicate exp)))
	(cproc (analyze (if-consequent exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (pred-value fail2)
	       (if (true? pred-value)
		   pred-value
		   (fail)))
	     (lambda ()
	       (cproc env succeed fail))))))

;;permanent-assignment
(define (permanent-assignment? exp) (tagged-list? exp 'permanent-set!))

(define (analyze-permanent-assignment exp)
  (let ((var (assignment-variable exp))
	(vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (set-variable-value! var val env)
	       (succeed 'ok
			(lambda () (fail2))))
	     fail))))

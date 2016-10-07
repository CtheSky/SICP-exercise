;;using frame implementation in ex 4-11
(define (unbind-var-in-frame var frame)
  (cond ((null? frame) 'done)
	((eq? var (car (car frame)))
	 (set-car! frame (cdr frame))
	 'done)
	(else
	 (unbind-var-in-frame var (cdr frame)))))
(define (make-unbound? exp)
  (tagged-list? exp 'make-unbound!))
(define (unbind-variable! exp env)
  (unbind-var-in-frame (cadr exp) (first-frame env)))


;;add in eval
(put-op 'make-unbound! unbind-variable!)

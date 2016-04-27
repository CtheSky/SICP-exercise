(define (let? exp) (tagged-list? exp 'let*)
(define (make-let vars body)
  (list 'let vars body))
(define (let*->nested-lets exp) 
  (define (make-nested-lets vars body)
    (if (null? vars)
	body
	(make-let
	      (list (car vars))
	      (make-nested-lets (cdr vars) body))))
  (make-nested-lets (cadr exp) (caddr exp)))

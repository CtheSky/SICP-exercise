(define (named-let? exp) (symbol? (cadr exp)))
(define (named-let-name exp) (cadr exp))
(define (named-let-vars exp) (let-vars (cdr exp)))
(define (named-let-inits exp) (let-inis (cdr exp)))
(define (named-let-body exp) (let-body (cdr exp)))

(define (let? exp) (taggged-list? exp 'let))
(define (let-body exp) (cddr exp))
(define (let-vars exp)
  (map car (cadr exp)))
(define (let-inits exp)
  (map cadr (cadr exp)))
(define (eval-let exp env)
  (eval (let->combination exp) env))
(define (let->combination exp)
  (if (named-let? exp)
      (sequence->exp
       (list 
	(list
	 'define
	 (cons (named-let-name exp) (named-let-vars exp))
	 (named-let-body exp))
	(cons
	 (cadr exp)
	 (named-let-inits exp))))
      (cons (make-lambda (let-vars exp) (let-body exp))
	    (let-inits exp))))

(put-op 'let eval-let)

;;inside analyze
((let? exp) (analyze (let->combination exp)))

;;let
(define (let? exp) (tagged-list? exp 'let))
(define (let-body exp) (cddr exp))
(define (let-vars exp)
  (map car (cadr exp)))
(define (let-inits exp)
  (map cadr (cadr exp)))
(define (eval-let exp env)
  (eval (let->combination exp) env))
(define (let->combination exp)
  (cons (make-lambda (let-vars exp) (let-body exp))
	(let-inits exp)))

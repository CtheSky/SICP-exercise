(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp exv))
	((and? exp) (eval-and exp env));;add and as special form
	((or? exp) (eval-or exp env));;add or as special form
	((lambda? exp)
	 (make-procedure (lambda-paramaters exp)
			 (lambda-body exp)
			 env))
	((begin? exp)
	 (eval-sequence (begin-actions exp) env))
	((cond? exp) (eval (cond-if exp) env))
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

(define (and? exp) (tagged-list? exp 'and))
(define (and-exps exp) (cdr exp))
(define (eval-and exp env)
  (let* ((seq (and-exps exp))
	 (first-exp (first-exp seq))
	 (result (eval first-exp)))
    (cond ((null? seq) 'true)
	  ((not (true? result)) 'false)
	  ((last-exp? first-exp) result)
	  (else (eval-and (rest-exps exp) env)))))

(define (or? exp) (tagged-list? exp 'or))
(define (or-exps exp) (cdr exp))
(define (eval-or exp env)
  (let* ((seq (and-exps exp))
	 (first-exp (first-exp seq))
	 (result (eval first-exp)))
    (cond ((null? seq) 'false)
	  ((true? result) 'true)
	  (else (eval-or (rest-exps exp) env)))))

(load "c:\\scheme\\ex\\make-table.scm")

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
(define (get-op type) 
  (get '2d->1d type));;use a fake tag to change 2d-table to 1d-table
(define (put-op type proc)
  (put '2d->1d type proc))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
        ((get-op (car exp))
	 ((get-op (car exp)) exp env))
	((application? exp)
	 (apply (eval (operator exp) env)
		(list-of-values (operands exp) env)))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

;;make a transform from 1-agru to 2-argu
(define (eval-quoted exp env)
  (text-of-quotation exp))
(define (eval-lambda exp env)
  (make-procedure (lambda-parameters exp)
		  (lambda-body exp)
		  env))
(define (eval-begin exp env)
  (eval-sequence (ben-actions exp) env))
(define (eval-cond exp env)
  (eval (cond->if exp) env))

;;put all eval functions
(put-op 'quoted eval-quoted)
(put-op 'assignment eval-assignment)
(put-op 'definition eval-definition)
(put-op 'if eval-if)
(put-op 'lambda eval-lambda)
(put-op 'begin eval-begin)
(put-op 'cond eval-cond)

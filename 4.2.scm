;;eval and apply
(define (eval exp env)
  (newline)
  (display "eval:")
  (display exp)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (eval-quoted exp env))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((lambda? exp) (eval-lambda exp env))
	((begin? exp) (eval-begin exp env))
	((cond? exp) (eval-cond exp env))
	((application? exp)
	 (apply (actual-value (operator exp) env)
	        (operands exp)
		env))
	(else
	 (error "Unknown expression type -- EVAL" exp))))

;;maintain a ref to scheme-apply
(define apply-in-underlying-scheme apply)
(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure 
	  procedure
	  (list-of-arg-values arguments env)))
	((compound-procedure? procedure)
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure)
	   (list-of-delayed-args arguments env)
	   (procedure-environment procedure))))
	(else
	 (error "Unknown expression type -- APPLY" procedure))))

;;thunk
(define (force-it obj)
  (cond ((thunk? obj)
	 (let ((result (actual-value 
			(thunk-exp obj)
			(thunk-env obj))))
	   (set-car! obj 'evaluated-thunk)
	   (set-car! (cdr obj) result)
	   (set-cdr! (cdr obj) '())
	   result))
	((evaluated-thunk? obj)
	 (thunk-value obj))
	(else obj)))

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj)
  (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))
(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))
(define (thunk-value evaluated-thunk) (cadr evaluated-thunk))


(define (actual-value exp env)
  (force-it (eval exp env)))

;;internal methods of eval
(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
	    (list-of-arg-values (rest-operands exps) env))))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps) env)
	    (list-of-delayed-args (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
	(else (actual-value (first-exp exps) env)
	      (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
		       (eval (assignment-value exp) env)
		       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
		    env)
  'ok)

(define (eval-quoted exp env)
  (let ((quoted-operand (text-of-quotation exp)))
    (if (pair? quoted-operand)
	(eval (make-lazy-list quoted-operand) env)
	quoted-operand)))

(define (eval-lambda exp env)
  (make-procedure (lambda-parameters exp)
		  (lambda-body exp)
		  env))

(define (eval-begin exp env)
  (eval-sequence (begin-actions exp) env))

(define (eval-cond exp env)
  (eval (cond->if exp) env))

;;tagged-list for dispathcing
(define (tagged-list? exp tag)
  (and (pair? exp) 
       (eq? (car exp) tag)))

;;self-evaluate
(define (self-evaluating? exp)
  (cond ((number? exp) true)
	((string? exp) true)
	(else false)))
;;variable
(define (variable? exp) (symbol? exp))
;;quoted
(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))
(define (make-quoted exp) (list 'quote exp))
(define (make-lazy-list items)
  (if (null? items)
      '()
      (list 'cons
	    (make-quoted (car items))
	    (make-lazy-list (cdr items)))))
;;assignment
(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))
;;defintion
(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))
(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
		   (cddr exp))))
;;lambda
(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))
;;if
(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))
;;begin
(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))
(define (sequence->exp seq)
  (cond ((null? seq) seq)
	((last-exp? seq) (first-exp seq))
	(else (make-begin seq))))
(define (make-begin seq) (cons 'begin seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))
;;cond
(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp)
  (expand-clause (cond-clauses exp)))
(define (expand-clause clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first)
	    (if (null? rest)
		(sequence->exp (cond-actions first))
		(error "ELSE clause isn't last -- COND->IF"
		       clauses))
	    (make-if (cond-predicate first)
		     (sequence->exp (cond-actions first))
		     (expand-clause rest))))))
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

;;predicate
(define (true? x)
  (not (eq? x false)))
(define (false? x)
  (eq? x false))

;;procedure
(define (make-procedure parameters body env)
  (list 'procedure 
	parameters
	body
	env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;;envrionment
(define (enclosing-envrionment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
	  (error "Too many arguments supplied" vars vals)
	  (error "Too few arguments supplied" vars vals))))
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-envrionment env)))
	    ((eq? var (car vars))
	     (if (eq? (car vals) '*unassigned*)
		 (error "Try to use an unassigned variable -- LOOKUP" var)
		 (car vals)))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable" env)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))
(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
	     (env-loop (enclosing-envrionment env)))
	    ((eq? var (car vars))
	     (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
	(error "Unbound variable -- SET!" env)
	(let ((frame (first-frame env)))
	  (scan (frame-variables frame)
		(frame-values frame)))))
  (env-loop env))
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
	     (add-binding-to-frame! var val frame))
	    ((eq? var (car vars))
	     (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
	  (frame-values frame))))

;;global environment
(define (setup-envrionment)
  (let ((initial-env
	 (extend-environment (primitive-procedure-names)
			     (primitive-procedure-objects)
			     the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))
(define primitive-procedures
  (list	(list 'eq? eq?)
	(list 'null? null?)
	(list '= =)
	(list '> >)
	(list '< <)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '/ /)
	(list 'list list)
	(list 'newline newline)
	(list 'display display)
	))
(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))
(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

;;imitate REPL
(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")
(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (actual-value input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))
(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compoud-procedure
		     (procedure-parameters object)
		     (procedure-body object)
		     '<procedure-env>))
      (display object)))

(define the-global-environment (setup-envrionment))

;;define lazy list-related procedure in driver loop
;;cons
(actual-value 
 '(define (cons x y) (lambda (m) (m x y)))
 the-global-environment)
;;car
(actual-value
 '(define (car z) (z (lambda (p q) p)))
 the-global-environment)
;;cdr
(actual-value 
 '(define (cdr z) (z (lambda (p q) q)))
 the-global-environment)
;;list-ref
(actual-value
 '(define (list-ref items n)
    (if (= n 0)
	(car items)
	(list-ref (cdr items) (- n 1))))
 the-global-environment)
;;map
(actual-value
 '(define (map proc items)
    (if (null? items)
	'()
	(cons (proc (car items))
	      (map proc (cdr items)))))
 the-global-environment)
;;scale-list
(actual-value
 '(define (scale-list items factor)
    (map (lambda (x) (* x factor))
	 items))
 the-global-environment)
;;add-lists
(actual-value
 '(define (add-lists list1 list2)
    (cond ((null? list1) list2)
	  ((null? list2) list1)
	  (else (cons (+ (car list1) (car list2))
		      (add-lists (cdr list1) (cdr list2))))))
 the-global-environment)

(driver-loop)
















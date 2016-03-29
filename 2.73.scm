;; Operation, type -> procedure
;; Dispatch table.
;; 
(define *op-table* (make-hash-table 'equal))
(define (put op type proc)
  (hash-table-put! *op-table* (list op type) proc))
(define (get op type)
  (hash-table-get *op-table* (list op type) '()))


(define  (deriv expr var)
	(cond ((number? exp) 0)
		  ((variable? expr) (if (same-variable? expr var) 1 0))
		  (else ((get 'deriv (operator expr)) (operands expr)
											  var))))
(define (variable? x) (symbol? x))
(define (same-variable? x1 x2) (and (variable? x1) (variable? x2) (eq? x1 x2)))											  
(define (operator expr) (car expr))
(define (operator expr) (cdr expr))

(define (install-sum-operator)
	;; internal procedures
	(define (make-sum a1 a2) (list '+ a1 a2))
	(define (addend s) (car s))
	(define (augend s) (cadr s))
	
	(define (make-product m1 m2) (list '* m1 m2))
	(define (multiplier p) (car p))
	(define (multiplicand p) (cadr p))
	
	(define (deriv-sum operands var)
		(make-sum (deriv (addend operands) var)
				  (deriv (augend operands) var)))
	(define (deriv-product operands var)
		(make-sum (make-product (multiplier expr)
							    (deriv (multiplicand expr) var))
				  (make-product (deriv (multiplier expr) var)
							    (multiplicand expr))))
								
	;; interface to the rest of the system
	(put 'deriv '+ deriv-sum)
	(put 'deriv '* deriv-product))
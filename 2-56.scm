(load "c:\\scheme\\ex\\2.3.2.scm")

(define (make-exponentiation base exponent)
	(cond ((=number? exponent 0) 1)
		  ((=number? exponent 1) base)
		  (else (list '** base exponent))))

(define (exponentiation? x) 
	(and (pair? x) (eq? '** (car x))))
(define (base e) (cadr e))
(define (exponent e) (caddr e))

(define (deriv expr var)
	(cond ((number? expr) 0)
		  ((variable? expr)
			(if (same-variable? expr var) 1 0))
		  ((exponentiation? expr)
			(let ((u (base expr))
				  (n (exponent expr)))
				(make-product 
					n
				   (make-product 
				        (make-exponentiation u (make-sum n -1))
						(deriv u var)))))
		  ((sum? expr)
			(make-sum (deriv (addend expr) var)
					  (deriv (augend expr) var)))
		  ((product? expr)
			(make-sum 
				(make-product (multiplier expr)
							  (deriv (multiplicand expr) var))
				(make-product (deriv (multiplier expr) var)
							  (multiplicand expr))))
		  (else 
			(error "unkown expression type -- DERIV" expr))))
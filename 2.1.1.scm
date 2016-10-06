(load "basic.scm")

(define (make-rat x y) 
	(let ((g (gcd x y)))
		(cons (/ x g) (/ y g))))
(define (number x) (car x))
(define (denom x) (cdr x))


(define (add-rat x y)
	(make-rat (+ (* (number x) (denom y))
		         (* (number y) (denom x)))
	          (* (denom x) (denom y))))
	   
(define (sub-rat x y)
	(make-rat (- (* (number x) (denom y))
				 (* (number y) (denom x)))
			  (* (denom x) (denom y))))

(define (mul-rat x y)
	(make-rat (* (number x) (number y))
			  (* (denom x) (denom y))))
			  
(define (div-rat x y)
	(make-rat (* (number x) (denom y))
			  (* (number y) (denom x))))

(define (print-rat x)
	(newline)
	(display (number x))
	(display "/")
	(display (denom x)))
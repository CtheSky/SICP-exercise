(define (average a b) (/ (+ a b) 2))
(define (square x) (* x x))
(define (cub x) (* x x x))
(define (inc x) (+ x 1))
(define (gcd a b)
	(define (gcd-iter a b)
		(if (zero? b)
			a
			(gcd-iter b (remainder a b))))
	(if (> a b)
		(gcd-iter a b)
		(gcd-iter b a)))
		
(define (prime? n)
	(define (smallest-diviser guess)
		(cond ((> (square guess) n) n) 
			  ((zero? (remainder n guess)) guess)
			  (else (smallest-diviser (+ guess 1)))))
	(equal? n (smallest-diviser 2)))
	
(define (compose f g)
	(lambda (x) (f (g x))))

(define (repeated f n)
	(define (iter g count)
		(if (= 1 count)
			g
			(iter (compose f g) (- count 1))))
	(if (zero? n)
		(lambda (x) x)
		(iter f n)))
	
(define (flatmap proc seq)
	(accumulate append '() (map proc seq)))
	
(define (accumulate op initial sequence)
	(if (null? sequence)
		initial
		(op (car sequence)
			(accumulate op initial (cdr sequence)))))
			
(define (enumerate-interval low high)
	(if (> low high)
		'()
		(cons low 
			  (enumerate-interval (+ 1 low) high))))
			  
(define (remove item sequence)
	(filter (lambda (x) (not (equal? x item)))
			sequence))
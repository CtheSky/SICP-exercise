(define (cons x y) (* (expt 2 x) (expt 3 y)))
(define (car z)
	(define (iter num n)
		(if (= 1 (gcd 2 num))
			n
			(iter (/ num 2) (+ 1 n))))
	(iter z 0))
(define (cdr z)
	(define (iter num n)
		(if (= 1 (gcd 3 num))
			n
			(iter (/ num 3) (+ 1 n))))
	(iter z 0))
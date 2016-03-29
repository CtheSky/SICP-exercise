(define (accumulate term combine null-val a next b)
	(if (> a b)
		null-val
		(combine (term a)
				 (accumulate term combine null-val (next a) next b))))

(define (sum term a next b)
	(define (plus a b) (+ a b))
	(accumulate term plus 0 a next b))
	
(define (product term a next b)
	(define (multiply a b) (* a b))
	(accumulate term multiply 1 a next b))
	
(define (accumulate-iter term combine null-val a next b)
	(define (iter a ret)
		(if (> a b)
			ret
			(iter (next a)
				  (combine (term a) ret))))
	(iter a null-val))
	
(define (sum-iter term a next b)
	(define (plus a b) (+ a b))
	(accumulate-iter term plus 0 a next b))
	
(define (product-iter term a next b)
	(define (multiply a b) (* a b))
	(accumulate-iter term multiply 1 a next b))

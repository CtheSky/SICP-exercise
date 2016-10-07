(define (filtered-accumulate combiner condition term null-val a next b)
	(cond ((> a b) null-val)
		  ((condition a) (combiner (term a)
								   (filtered-accumulate combiner condition term null-val (next a) next b)))
		  (else (filtered-accumulate combiner condition term null-val (next a) next b))))
		  
(define (sum condition term a next b)
	(define (plus a b) (+ a b))
	(filtered-accumulate plus condition term 0 a next b))
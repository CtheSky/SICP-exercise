;;recursion
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
		(accumulate combiner null-value term (next a) next b))))
;;iteration
(define (accumulate combiner null-value term a next b)
  (define (iter cur acc)
    (if (> cur b)
	acc
	(iter (next cur)
	      (combiner acc (term cur)))))
  (iter a null-value))

(define (sum term a next b)
  (accumulate + 0 term a next b))
(define (product term a next b)
  (accumulate * 1 term a next b))

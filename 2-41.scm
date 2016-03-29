(load "c:\\scheme\\ex\\2.2.3.scm")

(define (unique-3-sum-pairs n)
	(define (sum-right? 3-pair) (equal? n (+ (car 3-pair) (cadr 3-pair) (cadr (cdr 3-pair)))))
	(flatmap (lambda (x)
				(filter sum-right?
						(map (lambda (pair) (cons x pair))
							 (unique-pairs (- x 1)))))
			 (enumerate-interval 1 n)))
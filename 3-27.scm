(load "3.3.3.scm")

(define (memorize f)
  (let ((table (make-table-1d)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
	(or previously-computed-result
	    (let ((result (f x)))
	      (insert! x result table)
	      result))))))

(define memo-fib
  (memorize (lambda (n)
	      (cond ((= n 0) 0)
		    ((= n 1) 1)
		    (else (+ (memo-fib (- n 1))
			     (memo-fib (- n 2))))))))

;;calculate fib without internal define or letrec
(define fib
  (lambda (n)
   ((lambda (fib)
      (fib fib n))
    (lambda (f k)
      (if (<= k 1)
	  k
	  (+ (f f (- k 1))
	     (f f (- k 2))))))))

(define (my-even? x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))))

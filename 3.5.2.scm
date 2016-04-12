(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter (lambda (x) (not (divisible? x (stream-car stream))))
			 (stream-cdr stream)))))

;;define prime and fib by generating
(define primes-gen 
  (sieve (integers-starting-from 2)))

(define (fibgen a b)
  (cons-stream a (fibgen b (+ a b))))
(define fibs-gen (fibgen 0 1))


(define ones (cons-stream 1 ones))
(define (add-streams s1 s2)
  (stream-map + s1 s2))
(define (mul-streams s1 s2)
  (stream-map * s1 s2))
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

;;define integer, prime and double by implicit definition
(define integers (cons-stream 1 (add-streams ones integers)))
(define fibs
  (cons-stream 0
	       (cons-stream 1
			    (add-streams fibs
					 (stream-cdr fibs)))))
(define double (cons-stream 1 (scale-stream double 2)))

(define primes
  (cons-stream
   2
   (stream-filter prime? (integers-starting-from 3))))
(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
	  ((divisible? n (stream-car ps)) false)
	  (else (iter (stream-cdr ps)))))
  (iter primes))

(load "3.3.5.scm")

(define (c+ a b)
  (let ((sum (make-connector)))
    (adder a b sum)
    sum))

(define (c* a b)
  (let ((product (make-connector)))
    (multiplier a b product)
    product))

(define (c/ a b)
  (let ((quotient (make-connector)))
    (divider a b quotient)
    quotient))

(define (cv val)
  (let ((v (make-connector)))
    (constant val v)
    v))

(define (c-f-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
	  x)
      (cv 32)))

(define c (make-connector))
(define f (c-f-converter c))

(probe "c temp: " c)
(probe "f temp: " f)

(load "c:\\scheme\\ex\\3.3.5.scm")

(define (averager a b c)
  (let ((_a+b (make-connector))
	(_half (make-connector)))
    (adder a b _a+b)
    (multiplier _a+b _half c)
    (constant 0.5 _half)
    'ok))

(define a (make-connector))
(define b (make-connector))
(define c (make-connector))

(averager a b c)

(probe "a: " a)
(probe "b: " b)
(probe "c: " c)

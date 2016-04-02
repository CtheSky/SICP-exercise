(define f
  (lambda (first-value)
    (set! f (lambda (other-value) 0))
    first-value))

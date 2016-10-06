(load "3.1.2.scm")

(define rand
  (let ((x random-init))
    (lambda (m)
      (cond ((eq? m 'generate)
	     (set! x (random-update x))
	     x)
	    ((eq? m 'reset)
	     (lambda (set-value)
	       (begin (set! x set-value)
		      'set-value-done)))
	    (else
	     (error "Unknown request -- RAND"
		    m))))))

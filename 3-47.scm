(load "c:\\scheme\\ex\\3.4.scm")

(define (make-semaphore max)
  (let ((count max)
	(mutex (make-mutex)))
    (define (the-sema m)
      (cond ((eq? m 'acquire)
	     (mutex 'acquire)
	     (cond ((> count 0)
		    (set! count (- count 1))
		    (mutex 'release))
		   (else
		    (mutex 'release)
		    (the-sema 'acquire))))
	    ((eq? m 'release)
	     (mutex 'acquire)
	     (if (< count max)
		 (set! count (+ count 1)))
	     (mutex 'release))
	    (else
	     (error "Unknown operation -- MAKE-SEMAPHORE" m))))
    the-sema))
  
  

(load "c:\\scheme\\ex\\3.3.2.scm")

(define (print-queue queue)
  (define (print-iter front-ptr rear-ptr)
    (if (eq? front-ptr rear-ptr)
	(display (car rear-ptr))
	(begin (display (car front-ptr))
	       (display "  ")
	       (print-iter (cdr front-ptr) rear-ptr))))
  (if (empty-queue? queue)
      "Empty queue"
      (print-iter (front-ptr queue)
		  (rear-ptr queue))))

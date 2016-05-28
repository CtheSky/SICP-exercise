;;ramb
(define (ramb? exp) (tagged-list? exp 'ramb))
(define (ramb-choices exp) (shift-list (cdr exp)))

;;analyze-ramb
(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))));;change amb-choices to ramb 
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((car choices)
	     env 
	     succeed
	     (lambda () (try-next (cdr choices))))))
      (try-next cprocs))))

;;func to randomize the list
(define (shift-list items)
  (if (null? items)
      '()
      (let ((selected (list-ref items
				(random (length items)))))
	(cons selected
	      (shift-list (remove selected
				  items))))))

(define (remove x items)
  (cond ((null? items) '())
	((eq? x (car items)) 
	 (cdr items))
	(else (cons (car items)
		    (remove x (cdr items))))))

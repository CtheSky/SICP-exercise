(define (letrec->let exp)
  (let ((init-pairs (cadr exp))
	(body (let-body exp)))
    (make-let
     (map (lambda (init-pair)
	    (list (car init-pair)
		  (make-quoted '*unassigned*)))
	  init-pairs)
     (make-begin
      (append
       (map (lambda (init-pair)
	      (list 'set! 
		    (car init-pair)
		    (cadr init-pair)))
	    init-pairs)
       body)))))

(define (eval-letrec exp env)
  (eval (letrec->let exp) env))

(put-op 'lectrec eval-letrec)

(define (cond-recipient-clause? clause)
  (eq? (cadr clause) '=>))
(define (cond-recipient clause)
  (caddr clause))
(define (expand-clause clauses)
  (if (null? clauses) 
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(cond ((cond-else-clause? first)
	       (if (null? rest)
		   (sequence->exp (cond-actions first))
		   (error "ELSE clause isn't last -- COND->IF"
			  clauses)))
	      ((cond-recipient-clause? first)
	       (make-if (cond-predicate first)
			(list ;;use list to make it run during "complilation" phase
			 (cond-recipient clause)
			 (cond-predicaet first))
			(expand-clauses rest)))
	      (else
	       (make-if (cond-predicate first)
		     (sequence->exp (cond-actions first))
		     (expand-clauses rest)))))))

(define (assoc key records)
  (cond ((null? records) #f)
	((equal? key (caar records)) (car records))
	(else (assoc key (cdr records)))))

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
	(cdr record)
	#f)))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
	(set-cdr! record value)
	(set-cdr! table
		  (cons (cons key value)
			(cdr table)))))
  'done)

(define (make-table-1d) (list '*table*))

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
	(if subtable
	    (let ((record (assoc key-2 (cdr subtable))))
	      (if record
		  (cdr record)
		  #f))
	    #f)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
	(if subtable
	    (let ((record (assoc key-2 (cdr subtable))))
	      (if record
		  (set-cdr! record value)
		  (set-cdr! subtable
			    (cons (cons key-2 value)
				  (cdr subtable)))))
	    (set-cdr! local-table
		      (cons (list key-1 (cons key-2 value))
			    (cdr local-table)))))
      'done)
    (define (dispatch m)
      (cond ((eq? m 'lookup) lookup)
	    ((eq? m 'insert!) insert!)
	    (else (error "UNKOWN operation -- TABLE" m))))
    dispatch))

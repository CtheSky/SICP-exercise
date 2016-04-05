(define (key tree) (car tree))
(define (value tree) (cadr tree))
(define (left-branch tree) (caddr tree))
(define (right-branch tree) (cadddr tree))
(define (make-tree key value left right)
  (list key value left right))

(define (set-left-branch! tree left)
  (set-cdr! (cdr tree) (list left (right-branch tree))))
(define (set-right-branch! tree right)
  (set-car! (cdddr tree) right))
(define (set-value! tree value)
  (set-cdr! tree (list value
		       (left-branch tree)
		       (right-branch tree))))

(define (lookup key-given table)
  (define (iter tree)
    (cond ((null? tree) #f)
	  ((< key-given (key tree)) (iter (left-branch tree)))
	  ((> key-given (key tree)) (iter (right-branch tree)))
	  (else (value tree))))
  (iter (cadr table)))

(define (insert! key-given value table)
  (define (iter tree)
    (cond ((null? tree) (make-tree key-given value '() '()))
	  ((< key-given (key tree)) 
	   (set-left-branch! tree 
			     (iter (left-branch tree))))
	  ((> key-given (key tree))
	   (set-right-branch! tree
			      (iter (right-branch tree))))
	  (else
	   (set-value tree
		      value))))
  (if (null? (cdr table))
      (set-cdr! table 
		(cons (make-tree key-given value '() '())
		      (cdr table)))
      (iter (cadr table)))
  'done)

(define (make-table-1d) (list '*table*))

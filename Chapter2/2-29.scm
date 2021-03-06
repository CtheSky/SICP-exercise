(define (make-mobile left right)
	(list left right))
	
(define (make-branch length structure)
	(list length structure))

(define (left-branch mobile)
	(car mobile))
	
(define (right-branch mobile)
	(car (cdr mobile)))	

(define (branch-length branch)
	(car branch))

(define (branch-structure branch)
	(car (cdr branch)))
	
(define (total-weight mobile)
	(if (not (pair? mobile))
		mobile
		(+ (total-weight (left-branch mobile))
		   (total-weight (right-branch mobile)))))

(define (balance? mobile)
	(equal? (total-weight (left-branch mobile))
		    (total-weight (right-branch mobile))))
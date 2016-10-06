(load "2.2.3.scm")
(load "2-38.scm")

(define fold-right accumulate)

(define (reverse sequence)
	(define (iter seq ret)
		(if (null? seq)
			ret
			(iter (cdr seq)
				  (cons (car seq) ret))))
	(iter sequence '()))
	
(define (reverse-f-r sequence)
	(fold-right (lambda (x y)
					(append y (list x)))
				'()
				sequence))
				
(define (reverse-f-l sequence)
	(fold-left (lambda (x y) 
					(append (list y) x))
				'()
				sequence))
		
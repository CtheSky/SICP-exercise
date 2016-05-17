(define floors '(1 2 3 4 5))
(define (baker floors) (car floors))
(define (cooper floors) (cadr floors))
(define (fletcher floors) (caddr floors))
(define (miller floors) (cadddr floors))
(define (smith floors) (cadr (cdddr floors)))

(define (multiple-dwelling)
  (let ((restrictions (list (lambda (f) (not (= (baker f) 5)))
			    (lambda (f) (not (= (cooper f) 1)))
			    (lambda (f) (not (= (fletcher f) 5)))
			    (lambda (f) (not (= (fletcher f) 1)))
			    (lambda (f) (> (miller f) (cooper f)))
			    (lambda (f) (not (= 1 (abs (- (smith f)
							   (fletcher f))))))
			    (lambda (f) (not (= 1 (abs (- (cooper f)
							   (fletcher f)))))))))
    (filter (make-restrictions-to-filter restrictions)
	    (permutation floors))))

;;make-restrictions-to-filter
(define (make-restrictions-to-filter restrictions)
  (define (iter floors r)
    (if (null? r)
	true
	(and ((car r) floors)
	     (iter floors (cdr r)))))
  (lambda (floors)
    (iter floors restrictions)))

;;
;;permutation
(define (permutation items)
  (if (null? items)
      (list '())
      (append-map (lambda (x)
		    (map (lambda (rest-items)
			   (cons x rest-items))
			 (permutation (remove x items))))
		  items)))

(define (remove x items)
  (cond ((null? items) '())
	((eq? x (car items))
	 (cdr items))
	(else
	 (cons (car items) (remove x (cdr items))))))
			   

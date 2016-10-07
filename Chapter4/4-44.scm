(define (seq-1-to-n n)
  (define (seq-iter i)
    (if (> i n)
	'()
	(cons i (seq-iter (+ i 1)))))
  (seq-iter 1))

(define (list-amb lst)
  (if (null? lst)
      (amb)
      (amb (car lst) (list-amb (cdr lst)))))

(define (nth i lst)
  (cond ((null? lst) '())
	((= i 0) (car lst))
	(else (nth (- i 1) (cdr lst)))))

(define (attacks? row1 col1 row2 col2)
  (cond ((= row1 row2) true)
	((= col1 col2) true)
	((= (abs (- row1 row2))
	    (abs (- col1 col2)))
	 true)
	(else false)))

(define (safe-kth? k pos)
  (let ((kth-col (nth k pos))
	(pos-len (length pos)))
    (define (safe-iter i)
      (cond ((= i pos-len) true)
	    ((= i k) (safe-iter (+ i 1)))
	    (else
	     (let ((ith-col (nth i pos)))
	       (if (attacks? i ith-col k kth-col)
		   false
		   (safe-iter (+ i 1)))))))
    (safe-iter 0)))

(define (queens n)
  (define (queens-iter pos i)
    (if (> i (- n 1))
	pos
	(let ((new-col (list-amb (seq-1-to-n n))))
	  (let ((new-pos (append pos (list new-col))))
	    (require (safe-kth? i new-pos))
	    (queens-iter new-pos (+ i 1))))))
  (queens-iter '() 0))
		 

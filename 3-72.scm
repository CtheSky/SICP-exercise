(load "c:\\scheme\\ex\\3-70.scm")

(define square-sum
  (lambda (pair)
    (+ (square (car pair))
       (square (cadr pair)))))
(define square-sum-weighted-stream
  (weighted-pairs integers integers square-sum))

(define (stream-pick-3-adjacent-equal stream weight)
  (let ((pair1 (stream-car stream))
	(pair2 (stream-car (stream-cdr stream)))
	(pair3 (stream-car (stream-cdr (stream-cdr stream)))))
    (if (and (= (weight pair1) (weight pair2))
	     (= (weight pair2) (weight pair3)))
	(cons-stream (list (weight pair1) pair1 pair2 pair3)
		     (stream-pick-3-adjacent-equal (next-unequal stream (weight pair1) weight)
						   weight))
	(stream-pick-3-adjacent-equal (stream-cdr stream)
				      weight))))
(define (next-unequal stream weight-value weight)
  (if (= weight-value
	 (weight (stream-car stream)))
      (next-unequal (stream-cdr stream) weight-value weight)
      stream))

(define 3-way-square-sum 
  (stream-pick-3-adjacent-equal 
   square-sum-weighted-stream
   square-sum))
		     

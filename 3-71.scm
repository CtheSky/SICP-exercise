(load "3-70.scm")


(define cube
  (lambda (x) (* x x x)))
(define cube-sum-weight
  (lambda (pair)
    (+ (cube (car pair))
       (cube (cadr pair)))))
(define cube-sum-weighted-stream
  (weighted-pairs integers integers cube-sum-weight))

(define (stream-pick-adjacent-equal stream weight)
  (let ((pair1 (stream-car stream))
	(pair2 (stream-car (stream-cdr stream))))
    (if (= (weight pair1) (weight pair2))
	(cons-stream (list (weight pair1) pair1 pair2)
		     (stream-pick-adjacent-equal (next-unequal (stream-cdr stream)
							       (weight pair1)
							       weight)
						 weight))
	(stream-pick-adjacent-equal (stream-cdr stream) weight))))
(define (next-unequal stream weight-value weight)
  (if (= weight-value
	 (weight (stream-car stream)))
      (next-unequal (stream-cdr stream) weight-value weight)
      stream))

(define ramanujan
  (stream-pick-adjacent-equal 
   cube-sum-weighted-stream
   cube-sum-weight))
  

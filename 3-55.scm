(define (partial-sums stream)
  (define (iter last-sum current-stream)
    (let ((current-sum (+ last-sum
			  (stream-car current-stream))))
      (cons-stream current-sum
		   (iter current-sum (stream-cdr current-stream)))))
  (iter 0 stream))

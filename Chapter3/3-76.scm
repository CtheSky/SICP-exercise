(define (stream-smooth stream)
  (stream-map (lambda (a b) (/ (+ a b) 2))
	      (cons-stream 0 stream)
	      stream))

(define (make-zero-crossings input-stream transfomr)
  (let ((transformed (transform input-stream)))
    (stream-map sign-change-detector
		(cons-stream 0 transformed)
		transformed)))

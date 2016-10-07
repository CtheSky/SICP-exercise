;;original version
(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
			(stream-car input-stream))))
(define zero-crossings-orginal (make-zero-crossing sense-data 0))

;;stream-map version
(define zero-crossings
  (stream-map sign-crossings-detector 
	      senese-data
	      (cons-stream 0 senes-data)))

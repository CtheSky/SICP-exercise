(define (uniquely-asserted query frame-stream)
  (simple-stream-flatmap
   (lambda (frame)
     (let ((eval-stream
	    (qeval
	     (query-of-unique query)
	     (singleton-stream frame))))
       (if (singleton-stream? eval-stream)
	   eval-stream
	   the-empty-stream)))
   frame-stream))

(define (query-of-unique  uniq) (car uniq))

(define (singleton-stream? stream)
  (and (not (stream-null? stream))
       (stream-null? (stream-cdr stream))))

(put 'unique 'qeval uniquely-asserted)

(load "3.5.1.scm")

(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
      the-empty-stream
      (cons
       (apply proc (map stream-car argstreams))
       (apply stream-map
	      (cons proc (map stream-cdr argstreams))))))

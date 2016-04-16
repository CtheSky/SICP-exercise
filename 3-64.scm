(load "c:\\scheme\\ex\\3.5.3.scm")

(define (stream-limit stream tolerance)
  (if (> tolerance (abs (- (stream-car stream)
			   (stream-car (steam-cdr stream)))))
      (stream-car (stream-cdr stream))
      (stream-limit (stream-cdr stream) tolerance)))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

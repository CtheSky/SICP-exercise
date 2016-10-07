(load "3.3.4.scm")

;;or-gate could implemented by and-gate & inverter
;;a + b -> (a'b')'
(define (or-gate a b output)
  (let ((a- (make-wire))
	(b- (make-wire))
	(a-b- (make-wire)))
    (inverter a a-)
    (inverter b b-)
    (and-gate a- b- a-b-)
    (inverter a-b- output)
  'ok))

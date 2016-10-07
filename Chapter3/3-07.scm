(define (make-joint account old-psw new-psw)
  (define (dispatch given-psw m)
    (cond ((not (eq? given-psw new-psw))
	   "Incorrect password")
	  (else
	   (account old-psw m))))
  dispatch)

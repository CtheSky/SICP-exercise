(define (make-account balance password)
  (define (call-the-cops) "!!!")
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	(else "Insufficient funds")))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch psw-given m)
    (let ((count 0))
    (cond ((not (eq? psw-given password))
	   (set! count (+ count 1))
	   (if (>= count 7)
	       (lambda (amount) 
		 (begin (call-the-cops)
			"Incorrect password"))
	       (lambda (amount) "Incorrect password")))
	  ((eq? m 'withdraw)
	   (set! count 0)
	   withdraw)
	  ((eq? m 'deposit)
	   (set! count 0)
	   deposit)
	  (else (error "Unkown request -- MAKE-ACCOUNT"
		       m)))))
  dispatch)

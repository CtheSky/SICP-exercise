(load "3.4.scm")

(define (make-account balance account-no)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer (make-serialize)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
	    ((eq? m 'deposit) deposit)
	    ((eq? m 'balance) balance)
	    ((eq? m 'serializer) balance-serialize)
	    ((eq? m 'account-no) account-no)
	    (else (error "Unknown request -- MAKE-ACCOUNT"
			 m))))
    dispatch))

(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
	(serializer2 (account2 'serializer)))
    ((serailizer1 (serailizer2 (exchange)))
     account1
     account2)))

(define (exchange account1 account2)
  (let ((balance-diff (- (account1 'balance)
			 (account2 'balance)))
	(no-diff (- (account1 'account-no)
		    (account2 'account-no))))
    (cond ((> no-diff 0)
	   ((account1 'withdraw) balance-diff)
	   ((account2 'deposit) balance-diff))
	  (else
	   ((account2 'deposit) balance-diff)
	   ((account1 'withdraw) balance-diff)))))
	
		 

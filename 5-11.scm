;;11-b restore (register-name value) as a pair and check name when pop
(define (make-stack)
  (let ((s '()))
    (define (push x) (set! s (cons x s)))
    (define (pop reg-name)
      (if (null? s)
	  (error "Empty stack: POP")
	  (let ((top (car s)))
	    (cond ((not (eq? reg-name (car top)))
		   (error "Restore value from different register: ASSEMBLE" reg-name (car top)))
		  (else
		   (set! s (cdr s))
		   (cdr top))))))
    (define (initialize)
      (set! s '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
	    ((eq? message 'pop) pop)
	    ((eq? message 'initialize) (initialize))
	    (else (error "Unknown request: STACK" message))))
    dispatch))

;;11-c
(define (make-stack)
  (let ((stack-list '()))
    (define (push reg-pair) 
      (let ((reg-name (car reg-pair))
	    (reg-value (cdr reg-pair)))
	(let ((stack (assoc reg-name stack-list)))
	  (if stack
	      (set-cdr! stack (cons reg-value
				    (cdr stack)))
	      (set! stack-list (cons (cons reg-name 
					   (cons reg-value '()))
				     stack-list))))))
    (define (pop reg-name)
      (let ((stack (assoc reg-name stack-list)))
	(if (null? stack)
	    (error "Empty stack for thie register: POP")
	    (let ((top (cadr stack)))
	      (set-cdr! stack (cddr stack))
	      top))))
    (define (initialize)
      (set! stack-list '())
      'done)
    (define (dispatch message)
      (cond ((eq? message 'push) push)
	    ((eq? message 'pop) pop)
	    ((eq? message 'initialize) (initialize))
	    (else (error "Unknown request: STACK" message))))
    dispatch))

;;common parts for 11-b and 11-c make save and restore including register name
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
			   (stack-inst-reg-name inst))))
    (lambda ()
      ((stack 'push) (cons (stack-inst-reg-name inst)
			(get-contents reg)))
      (advance-pc pc))))
(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
			   (stack-inst-reg-name inst))))
    (lambda ()
      (set-contents! reg ((stack 'pop) (stack-inst-reg-name inst)))
      (advance-pc pc))))
(define (stack-inst-reg-name stack-instructioin)
  (cadr stack-instructioin))

;;maintain a state variable and check it for whether print instruction during execution
(define (make-new-machine)
  (let ((pc (make-register 'pc))
	(flag (make-register 'flag))
	(stack (make-stack))
	(instruction-count 0);;
	(instruction-trace-on false);;***
	(the-instruction-sequence '()))
    (let ((the-ops
	   (list (list 'initialize-stack
		       (lambda () (stack 'initialize)))
		 (list 'print-stack-statistics
		       (lambda () (stack 'print-statistics)))))
	  (register-table
	   (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
	(if (assoc name register-table)
	    (error "Multiply defined register: " name)
	    (set! register-table
		  (cons (list name (make-register name))
			register-table)))
	'register-allocated)
      (define (lookup-register name)
	(let ((val (assoc name register-table)))
	  (if val
	      (cadr val)
	      (error "Unknown register: " name))))
      (define (execute)
	(let ((insts (get-contents pc)))
	  (if (null? insts)
	      'done
	      (begin
		(set! instruction-count (+ 1 instruction-count))
		(let ((next-inst (car insts)))
		  (if instruction-trace-on;;***
		      (begin (newline) (display next-inst)))
		  ((instruction-execution-proc next-inst)))
		(execute)))))
      (define (dispatch message)
	(cond ((eq? message 'start)
	       (set-contents! pc the-instruction-sequence)
	       (execute))
	      ((eq? message 'install-instruction-sequence)
	       (lambda (seq)
		 (set! the-instruction-sequence seq)))
	      ((eq? message 'allocate-register)
	       allocate-register)
	      ((eq? message 'get-register)
	       lookup-register)
	      ((eq? message 'install-operations)
	       (lambda (ops)
		 (set! the-ops (append the-ops ops))))
	      ((eq? message 'stack) stack)
	      ((eq? message 'operations) the-ops)
	      ((eq? message 'get-instruction-count)
	       (let ((count instruction-count))
		 (set! instruction-count 0)
		 count))
	      ((eq? message 'trace-on) (set! instruction-trace-on true));;***
	      ((eq? message 'trace-off) (set! instruction-trace-on false));;***
	      (else (error "Unknown request: MACHINE" message))))
      dispatch)))

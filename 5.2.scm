;;Make-machine
(define (make-machine register-names ops controller-text)
  (let ((machine (make-new-machine)))
    (for-each (lambda (register-name)
		((machine 'allocate-register) register-name))
	      register-names)
    ((machine 'install-operations) ops)
    ((machine 'install-instruction-sequence)
     (assemble controller-text machine))
    machine))

;;Registers
(define (make-register name)
  (let ((contents '*unassigned*)
	(trace-on false));;ex 5-18
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set)
             (lambda (value) 
	       (if trace-on
		   (begin (newline) (display name) (display contents) (display " --> ") (display value)))
	       (set! contents value)))
	    ((eq? message 'trace-on) (set! trace-on true))
	    ((eq? message 'trace-off) (set! trace-on false))
            (else
             (error "Unknown request -- REGISTER" message))))
    dispatch))

(define (get-contents register) (register 'get))
(define (set-contents! register value)
  ((register 'set) value))

;;Stack
(define (make-stack)
  (let ((stack-list '());;ex-5.11-c
	(number-pushes 0)
	(max-depth 0)
	(current-depth 0))
    (define (push reg-pair) 
      (let ((reg-name (car reg-pair))
	    (reg-value (cdr reg-pair)))
	(let ((stack (assoc reg-name stack-list)))
	  (if stack
	      (set-cdr! stack (cons reg-value
				    (cdr stack)))
	      (set! stack-list (cons (cons reg-name 
					   (cons reg-value '()))
				     stack-list)))))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth (max current-depth max-depth)))
    (define (pop reg-name)
      (let ((stack (assoc reg-name stack-list)))
	(if (null? stack)
	    (error "Empty stack for thie register: POP")
	    (let ((top (cadr stack)))
	      (set-cdr! stack (cddr stack))
	      (set! current-depth (- current-depth 1))
	      top))))
    (define (initialize)
      (set! stack-list '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)
    (define (print-statistics)
      (newline)
      (display (list 'total-pushes '= number-pushes
		     'maximum-depth '= max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
	    ((eq? message 'pop) pop)
	    ((eq? message 'initialize) (initialize))
	    ((eq? message 'print-statistics) (print-statistics))
	    (else (error "Unknown request: STACK" message))))
    dispatch))

;;Basic Machine
(define (make-new-machine)
  (let ((pc (make-register 'pc))
	(flag (make-register 'flag))
	(stack (make-stack))
	(instruction-count 0);;ex 5-15
	(instruction-trace-on false);;ex 5-16
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
		  (if instruction-trace-on
		      (begin (newline) (display next-inst)))
		  ((instruction-execution-proc next-inst)))
		(execute)))))
      (define (set-register-trace! name trace-msg)
	(let ((reg (assoc name register-table)))
	  (if reg
	      ((cadr reg) trace-msg)
	      (error "Unknown register: " name))))
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
	      ((eq? message 'trace-on) (set! instruction-trace-on true))
	      ((eq? message 'trace-off) (set! instruction-trace-on false))
	      ((eq? message 'reg-trace-on)
	       (lambda (reg-name)
		 (set-register-trace! reg-name 'trace-on)))
	      ((eq? message 'reg-trace-off)
	       (lambda (reg-name)
		 (set-register-trace! reg-name 'trace-off)))
	      (else (error "Unknown request: MACHINE" message))))
      dispatch)))

(define (start machine) (machine 'start))
(define (get-register machine register-name)
  ((machine 'get-register) register-name))
(define (get-register-contents machine register-name)
  (get-contents (get-register machine register-name)))
(define (set-register-contents! machine register-name value)
  (set-contents! (get-register machine register-name)
		 value)
  'done)


;;Assembler
(define (assemble controller-text machine)
  (extract-labels
   controller-text
   (lambda (insts labels)
     (update-insts! insts labels machine)
     insts)))

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels
       (cdr text)
       (lambda (insts labels)
	 (let ((next-inst (car text)))
	   (if (symbol? next-inst)
	       (if (label-exists? next-inst labels);;ex-5.8
		   (error "Label name duplicated: ASSEMBLE" next-inst)
		   (receive insts
			    (cons (make-label-entry next-inst insts)
				  labels)))
	       (receive (cons (make-instruction next-inst)
			      insts)
			labels)))))))
(define (label-exists? label-name labels)
  (assoc label-name labels))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
	(flag (get-register machine 'flag))
	(stack (machine 'stack))
	(ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc!
	inst
	(make-execution-procedure
	 (instruction-text inst)
	 labels machine pc flag stack ops)))
     insts)))

(define (make-instruction text) (cons text '()))
(define (instruction-text inst) (car inst))
(define (instruction-execution-proc inst) (cdr inst))
(define (set-instruction-execution-proc! inst proc)
  (set-cdr! inst proc))
(define (make-label-entry label-name insts)
  (cons label-name insts))
(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
	(cdr val)
	(error "Undefined label: ASSENBLE" label-name))))

;;Generating Execution Procedures for Instructions
(define (make-execution-procedure
	 inst labels machine pc flag stack ops)
  (cond ((eq? (car inst) 'assign)
	 (make-assign inst machine labels ops pc))
	((eq? (car inst) 'test)
	 (make-test inst machine labels ops flag pc))
	((eq? (car inst) 'branch)
	 (make-branch inst machine labels flag pc))
	((eq? (car inst) 'goto)
	 (make-goto inst machine labels pc))
	((eq? (car inst) 'save)
	 (make-save inst machine stack pc))
	((eq? (car inst)'restore)
	 (make-restore inst machine stack pc))
	((eq? (car inst) 'perform)
	 (make-perform inst machine labels ops pc))
	(else (error "Unknown instruction type: ASSEMBLE" inst))))

(define (make-assign inst machine labels operations pc)
  (let ((target
	 (get-register machine (assign-reg-name inst)))
	 (value-exp (assign-value-exp inst)))
    (let ((value-proc
	   (if (operation-exp? value-exp)
	       (make-operation-exp
		value-exp machine labels operations)
	       (make-primitive-exp
		(car value-exp) machine labels))))
      (lambda ()
	(set-contents! target (value-proc))
	(advance-pc pc)))))
(define (assign-reg-name assign-instruction)
  (cadr assign-instruction))
(define (assign-value-exp assign-instruction)
  (cddr assign-instruction))
(define (advance-pc pc)
  (set-contents! pc (cdr (get-contents pc))))

(define (make-test inst machine labels operations flag pc)
  (let ((condition (test-condition inst)))
    (if (operation-exp? condition)
	(let ((condition-proc
	       (make-operation-exp
		condition machine labels operations)))
	  (lambda ()
	    (set-contents! flag (condition-proc))
	    (advance-pc pc)))
	(error "Bad TEST instruction: ASSEMBLE" inst))))
(define (test-condition test-instruction)
  (cdr test-instruction))

(define (make-branch inst machine labels flag pc)
  (let ((dest (branch-dest inst)))
    (if (label-exp? dest)
	(let ((insts
	       (lookup-label labels (label-exp-label dest))))
	  (lambda ()
	    (if (get-contents flag)
		(set-contents! pc insts)
		(advance-pc pc))))
	(error "Bad BRANCH instruction: ASSEMBLE" inst))))
(define (branch-dest branch-instruction)
  (cadr branch-instruction))

(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
	   (let ((insts (lookup-label
			 labels
			 (label-exp-label dest))))
	     (lambda () (set-contents! pc insts))))
	  ((register-exp? dest)
	   (let ((reg (get-register
		       machine
		       (register-exp-reg dest))))
	     (lambda () (set-contents! pc (get-contents reg)))))
	  (else (error "Bad GOTO instruction: ASSEMBLE" inst)))))
(define (goto-dest goto-instruction)
  (cadr goto-instruction))

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

(define (make-perform inst machine labels operations pc)
  (let ((action (perform-action inst)))
    (if (operation-exp? action)
	(let ((action-proc
	       (make-operation-exp
		action machine labels operations)))
	  (lambda () (action-proc) (advance-pc pc)))
	(error "Bad PERFORM instruction: ASSEMBLE" inst))))
(define (perform-action inst) (cdr inst))

;;Execution procedures for subexpressions
(define (make-primitive-exp exp machine labels)
  (cond ((constant-exp? exp)
	 (let ((c (constant-exp-value exp)))
	   (lambda () c)))
	((label-exp? exp)
	 (let ((insts (lookup-label
		       labels
		       (label-exp-label exp))))
	   (lambda () insts)))
	((register-exp? exp)
	 (let ((r (get-register machine (register-exp-reg exp))))
	   (lambda () (get-contents r))))
	(else (error "Unknown expression type: ASSEMBLE" exp))))
(define (register-exp? exp) (tagged-list? exp 'reg))
(define (register-exp-reg exp) (cadr exp))
(define (constant-exp? exp) (tagged-list? exp 'const))
(define (constant-exp-value exp) (cadr exp))
(define (label-exp? exp) (tagged-list? exp 'label))
(define (label-exp-label exp) (cadr exp))

(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp)
			 operations))
	(aprocs 
	 (map (lambda (e)
		(if (label-exp? e);;ex-5.9
		    (error "Using label as operands: ASSEMBLE" e)
		    (make-primitive-exp e machine labels)))
	      (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))
(define (operation-exp? exp)
  (and (pair? exp) (tagged-list? (car exp) 'op)))
(define (operation-exp-op operation-exp)
  (cadr (car operation-exp)))
(define (operation-exp-operands operation-exp)
  (cdr operation-exp))
(define (lookup-prim symbol operations)
  (let ((val (assoc symbol operations)))
    (if val
	(cadr val)
	(error "Unknown operation: ASSEMBLE" symbol))))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

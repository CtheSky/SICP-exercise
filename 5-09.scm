;;Check whether operand is label before get its proc
(define (make-operation-exp exp machine labels operations)
  (let ((op (lookup-prim (operation-exp-op exp)
			 operations))
	(aprocs 
	 (map (lambda (e)
		(if (label-exp? e)                                 ;;***    
		    (error "Using label as operands: ASSEMBLE" e)  ;;***
		    (make-primitive-exp e machine labels)))
	      (operation-exp-operands exp))))
    (lambda ()
      (apply op (map (lambda (p) (p)) aprocs)))))

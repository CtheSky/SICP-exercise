;;For fact(n), max-depth will be 2n-2
;;Enter -1 to quit
(define fact
  (make-machine
   '(n val continue)
   (list (list '= =) (list '* *) (list '- -) (list 'read read))
   '(
     read-loop 
     (assign n (op read))
     (test (op =) (reg n) (const -1))
     (branch (label done))
     (assign continue (label fact-done))
     fact-loop
     (test (op =) (reg n) (const 1))
     (branch (label base-case))
     (save continue)
     (save n)
     (assign n (op -) (reg n) (const 1))
     (assign continue (label after-fact))
     (goto (label fact-loop))
     after-fact
     (restore n)
     (restore continue)
     (assign val (op *) (reg n) (reg val))
     (goto (reg continue))
     base-case
     (assign val (const 1))
     (goto (reg continue))
     fact-done
     (perform (op print-stack-statistics))     
     (perform (op initialize-stack))
     (goto (label read-loop))
     done)))

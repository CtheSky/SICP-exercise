;Recurive
(controller
 (assign continue (label expt-done))
 expt-loop
   (test (op =) (reg n) (const 0))
   (branch (label base-case))
   (save continue)
   (assign continue (label after-expt))
   (goto (label expt-loop))
 after-expt
   (restore continue)
   (assign val (op *) (reg val) (reg b))
   (goto (reg continue))
 base-case
   (assign val (const 1))
   (goto (reg continue))
 expt-done)

;;Iterative
(controller
 (assign count (const 0))
 (assign product (const 1))
 expt-loop
   (test (op =) (reg count) (const 0))
   (branch (label expt-done))
   (assign product (op *) (reg b) (reg product))
   (assign count (op -) (reg count) (const 1))
   (goto (label expt-loop))
 expt-done)

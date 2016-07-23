(controller
  (assign guess (const 1))
  sqrt-iter
   (assign r1 (op *) (reg x) (reg guess))
   (assign r1 (op -) (reg r1) (reg guess))
   (assign r1 (op abs) (reg r1))
   (test (op <) (reg r1) (const 0.001))
   (branch (lanbel sqrt-done))
   (assign r1 (op /) (reg x) (reg guess))
   (assign r1 (op +) (reg r1) (reg guess))
   (assign r1 (op /) (reg r1) (const 2))
   (goto (label sqrt-iter))
  sqrt-done)

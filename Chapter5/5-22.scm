;;append
(define append-regsim
  (make-machine
   '(continue x y elem ret)
   (list (list 'cons cons) (list 'car car) (list 'cdr cdr) (list 'pair? pair?) (list 'null? null?))
   '(
     (assign continue (label append-done))

     append-loop
     (save continue)
     (test (op null?) (reg x))
     (branch (label tail-of-x))
     (assign elem (op car) (reg x))
     (save elem)
     (assign x (op cdr) (reg x))
     (assign continue (label after-append-loop))
     (goto (label append-loop))

     tail-of-x
     (assign ret (reg y))
     (restore continue)
     (goto (reg continue))
     
     after-append-loop
     (restore elem)
     (assign ret (op cons) (reg elem) (reg ret))
     (assign x (op cons) (reg elem) (reg x))
     (restore continue)
     (goto (reg continue))

     append-done)))
     
;;append!
(define append!-regsim
  (make-machine
   '(continue x y elem)
   (list (list 'cons cons) (list 'car car) (list 'cdr cdr) (list 'pair? pair?) (list 'null? null?))
   '(
     (assign continue (label append-done))

     append-loop
     (save continue)
     (test (op null?) (reg x))
     (branch (label tail-of-x))
     (assign elem (op car) (reg x))
     (save elem)
     (assign x (op cdr) (reg x))
     (assign continue (label after-append-loop))
     (goto (label append-loop))

     tail-of-x
     (assign x (reg y))
     (restore continue)
     (goto (reg continue))
     
     after-append-loop
     (restore elem)
     (assign x (op cons) (reg elem) (reg x))
     (restore continue)
     (goto (reg continue))

     append-done)))

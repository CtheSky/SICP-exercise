;;Recursive count-leaves
(define count-leaves-recursive 
  (make-machine
   '(continue temp val tree)
   (list (list '= =) (list '+ +) (list 'car car) (list 'cdr cdr) (list 'pair? pair?) (list 'null? null?))
   '(
     (assign continue (label count-leaves-done))
     (save tree)
     count-leaves-loop
     (restore tree)
     (save continue)
     (test (op null?) (reg tree))
     (branch (label count-leaves-null))
     (test (op pair?) (reg tree))
     (branch (label count-leaves-pair))
     (goto (label count-leaves-atom))
     
     count-leaves-null
     (assign val (const 0))
     (restore continue)
     (goto (reg continue))
     
     count-leaves-atom
     (assign val (const 1))
     (restore continue)
     (goto (reg continue))
     
     count-leaves-pair
     (save tree)
     (assign tree (op car) (reg tree))
     (save tree)
     (assign continue (label after-count-left-tree))
     (goto (label count-leaves-loop))
     
     after-count-left-tree
     (restore tree)
     (save val)
     (assign tree (op cdr) (reg tree))
     (save tree)
     (assign continue (label after-count-right-tree))
     (goto (label count-leaves-loop))
     
     after-count-right-tree
     (assign temp (reg val))
     (restore val)
     (assign val (op +) (reg temp) (reg val))
     (restore continue)
     (goto (reg continue))
     
     count-leaves-done)))

;;Recursive count-leaves with explicit counter
(define count-leaves-explicit-counter
  (make-machine
   '(continue counter tree)
   (list (list '= =) (list '+ +) (list 'car car) (list 'cdr cdr) (list 'pair? pair?) (list 'null? null?))
   '(
     (assign continue (label count-leaves-done))
     (assign counter (const 0))
     (save tree)
     count-leaves-loop
     (restore tree)
     (save continue)
     (test (op null?) (reg tree))
     (branch (label count-leaves-null))
     (test (op pair?) (reg tree))
     (branch (label count-leaves-pair))
     (goto (label count-leaves-atom))
     
     count-leaves-null
     (restore continue)
     (goto (reg continue))
     
     count-leaves-atom
     (assign counter (op +) (reg counter) (const 1))
     (restore continue)
     (goto (reg continue))
     
     count-leaves-pair
     (save tree)
     (assign tree (op car) (reg tree))
     (save tree)
     (assign continue (label after-count-left-tree))
     (goto (label count-leaves-loop))
     
     after-count-left-tree
     (restore tree)
     (assign tree (op cdr) (reg tree))
     (save tree)
     (assign continue (label after-count-right-tree))
     (goto (label count-leaves-loop))
     
     after-count-right-tree
     (restore continue)
     (goto (reg continue))
     
     count-leaves-done)))

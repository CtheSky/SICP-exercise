(define (liars-puzzle)
  (let ((betty (amb 1 2 3 4 5))
	(ethel (amb 1 2 3 4 5))
	(joan (amb 1 2 3 4 5))
	(kitty (amb 1 2 3 4 5))
	(mary (amb 1 2 3 4 5)))
    (require (xor (= kitty 2)
		  (= betty 3)))
    (require (xor (= ethel 1)
		  (= joan 2)))
    (require (xor (= joan 3)
		  (= ethel 5)))
    (require (xor (= kitty 2)
		  (= mary 4)))
    (require (xor (= mary 4)
		  (= betty 1)))
    (require (distinct? (list betty ethel joan kitty mary)))
    (list (list 'betty betty)
	  (list 'ethel ethel)
	  (list 'joan joan)
	  (list 'kitty kitty)
	  (list 'mary mary))))

;;there is only one solution
;;((betty 3) (ethel 5) (joan 2) (kitty 1) (mary 4))

	   
;;xor which only holds 2 predicates 
;;since amb from support file dosen't have and,or
;;so here use a naive implementation
(define (xor p1 p2)
  (if p1
      (if p2
	  false
	  true)
      (if p2
	  true
	  false)))
	  

(load "basic.scm")

(define empty-board '())
(define (row position) (car position))
(define (col position) (cadr position))

(define (adjoin-position row col rest-positions)
	(append rest-positions (list (list row col))))

(define (safe? k board)
	(let ((position-k (car ((repeated cdr (- k 1)) board))))
		(not (accumulate (lambda (position rest-checks) 
							(or (equal? (row position)
										(row position-k))
								(equal? (abs (- (row position)
												(row position-k)))
										(abs (- (col position)
												(col position-k))))
								rest-checks))
						 #f
						 (remove position-k board)))))

(define (queens board-size)
	(define (queen-cols k)
		(if (= k 0)
			(list empty-board)
			(filter (lambda (board) (safe? k board))
					(flatmap (lambda (rest-of-queens)
								(map (lambda (new-row)
										(adjoin-position new-row k rest-of-queens))
									 (enumerate-interval 1 board-size)))
							 (queen-cols (- k 1))))))
	(queen-cols board-size))
	

(load "2-36.scm")

(define (dot-product v w)
	(accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
	(map (lambda (col)
			(dot-product col v))
		 m))
		 
(define (transpose mat)
	(accumulate-n cons
				  '()
				  mat))
				  
(define (matrix-*-matrix m n)
	(let ((cols (transpose n)))
		(map (lambda (col-m)
				(map (lambda (col-n)
						(dot-product col-m col-n))
					 cols))
			 m)))
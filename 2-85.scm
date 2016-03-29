;;into rational package
(put 'project '(rational)
	(lambda (r) 
		(make-scheme-number
			(floor
				(/ (numer r) (denom r))))))
	
;;into real package
(put 'project '(real)
	(lambda (r) (make-rational r 1)))

;;into complex package
(put 'project '(complex)
	(lambda (c) (make-real (real-part c))))

(define (drop num)
	(let ((project-proc (get 'project (list (type-tag num)))))
		(if project-proc
			(let ((dropped (project num)))
				(if (equ? num (raise drop))
				(drop dropped)
				num)))
			num))
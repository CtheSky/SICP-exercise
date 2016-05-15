(define (eval-quoted exp env)
  (let ((quoted-operand (text-of-quotation exp)))
    (if (pair? quoted-operand)
	(eval (make-lazy-list quoted-operand) env)
	quoted-operand))

(define (make-lazy-list items)
  (if (null? items)
      '()
      (list 'cons
	    (make-quoted (car items));;inside item should be quoted
	    (make-lazy-list (cdr items)))))

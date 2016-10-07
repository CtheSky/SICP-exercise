(load "2.2.3.scm")

(define (accumulate-n op initial seqs)
	(if (null? (car seqs))
		'()
		(cons (accumulate op initial (map car seqs))
			  (accumulate-n op initial (map cdr seqs)))))
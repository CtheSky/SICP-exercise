(load "c:\\scheme\\ex\\2-64.scm")

(define (element-of-set? x set)
	(cond ((null? set) #f)
		  ((= x (entry set)) #t)
		  ((< x (entry set))
			(element-of-set? x (left-branch set)))
		  ((> x (entry set))
		    (element-of-set? x (right-branch set)))))
			
(define (adjoin-set x set)
	(cond ((null? set) (make-tree x '() '()))
		  ((= x (entry set)) set)
		  ((< x (entry set))
			(make-tree (entry set)
					   (adjoin-set x (left-branch set))
					   (right-branch set)))
		  ((> x (entry set))
			(make-tree (entry set)
					   (left-branch set)
					   (adjoin-set x (right-branch set))))))
					   
(define (union-set set1 set2)
	(define (merge-sorted-list list1 list2 ret)
		(cond ((null? list1) (append ret list2))
			  ((null? list2) (append ret list1))
			  (else (let ((x1 (car list1)) (x2 (car list2)))
						(cond ((< x1 x2) (merge-sorted-list (cdr list1)
															list2
															(append ret (list x1))))
							  ((< x2 x1) (merge-sorted-list list1
															(cdr list2)
															(append ret (list x2))))
							  ((= x1 x2) (merge-sorted-list (cdr list1)
															(cdr list2)
															(append ret (list x1)))))))))
	(list->tree (merge-sorted-list (tree->list-2 set1) 
								   (tree->list-2 set2)
								   '())))
(define (intersection-set set1 set2)
	(define (merge-sorted-list list1 list2 ret)
		(if (or (null? list1) (null? list2))
			ret
			(let ((x1 (car list1)) (x2 (car list2)))
				(cond ((< x1 x2) (merge-sorted-list (cdr list1) list2 ret))
					  ((< x2 x1) (merge-sorted-list list1 (cdr list2) ret))
					  ((= x1 x2) (merge-sorted-list (cdr list1) (cdr list2) (append ret (list x1))))))))
	(list->tree (merge-sorted-list (tree->list-2 set1)
								   (tree->list-2 set2)
								   '())))
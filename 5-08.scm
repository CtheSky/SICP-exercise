;;Check whether label is in the label list and send an error
(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels
       (cdr text)
       (lambda (insts labels)
	 (let ((next-inst (car text)))
	   (if (symbol? next-inst)
	       (if (label-exists? next-inst labels)                    ;;***
		   (error "Label name duplicated: ASSEMBLE" next-inst) ;;***
		   (receive insts
			    (cons (make-label-entry next-inst insts)
				  labels)))
	       (receive (cons (make-instruction next-inst)
			      insts)
			labels)))))))

(define (label-exists? label-name labels)                              ;;***
  (assoc label-name labels))

(define (find-binding-in-frame var frame)
  (define (scan vars vals)
    (cons ((nul? vars)
	   (cons '() '()))
	  ((eq? var (car vars))
	   (cons #t (car vals)))
	  (else
	   (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame)
	(frame-values frame)))
(define (set-binding-in-frame! var val frame)
  (define (scan vars vals)
    (cond ((null? vars) '())
	  ((eq? var (car vars))
	   (set-car! vals val)
	   #t)
	  (else
	   (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame)
	(frame-values frame)))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
	(error "Unbound variable" var)
	(let ((result (find-binding-in-frame var (first-frame env))))
	  (if (car result)
	      (cdr result)
	      (env-loop (enclosing-envrionment env))))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (if (eq? env the-empty-envionment)
	(error "Unbound variable -- SET!" var)
	(if (set-binding-in-frame! var val (first-frame env))
	    #t
	    (env-loop (enclosing-envrionment env)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (if (set-binding-in-frame! frame var val)
	#t
	(add-binding-to-frame! frame var val))))

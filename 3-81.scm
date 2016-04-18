(load "c:\\scheme\\ex\\3.5.5.scm")

(define (random-from-command command-stream)
  (define random-number
    (cons-stream random-init
		 (stream-map (lambda (number command)
			       (cond    
				((null? command) the-empty-stream)     
				((eq? command 'generator)       
				 (random-update number))    
                                ((and (pair? command)              
                                      (eq? (car command) 'reset))    
                                 (cdr command))      
                                (else     
                                 (error "Bad command -- RANDOM-FROM-COMMAND " command))))        
			     random-number        
			     command-stream)))
  random-number)

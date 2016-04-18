(load "c:\\scheme\\ex\\3.5.3.scm")

(define (RC= R C dt)
  (lambda (v0 i-stream)
    (add-streams
     (scale-stream i-stream R)
     (scale-stream (integral i-stream v0 dt)
		  (/ 1 C))))) 

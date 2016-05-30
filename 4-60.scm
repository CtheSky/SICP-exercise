(rule (lives-near-2 ?person-1 ?person-2)
      (and (address ?person-1 (?town . ?rest-1))
	   (address ?person-2 (?town . ?rest-2))
	   (lisp-value greater-as-string ?person-1 ?person-2)))

(define (greater-as-string a b)
  (string>? (symbol->string (car a))
	    (symbol->string (car b))))

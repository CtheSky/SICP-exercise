;;give the melissa and maryann a value instead of amb makes it more effective
;;for the require sentence it is hard to decide which level you will improve it to
;;I mean sometimes the answer is already there
(define (daughter-puzzle)
    (let ((gabrielle (amb 'moore 'downing 'hall 'parker))
          (lorna (amb 'downing 'hall 'barnacle 'parker))
          (rosalind (amb 'moore 'downing 'barnacle 'parker))
          (melissa 'barnacle)
          (maryann 'moore))
      (require 
        (cond ((eq? gabrielle 'downing) (eq? melissa 'parker))
              ((eq? gabrielle 'hall) (eq? rosalind 'parker))
              (else false)))
      (require 
        (distinct? (list gabrielle lorna rosalind melissa maryann)))
      (list (list 'gabrielle gabrielle)
            (list 'lorna lorna)
            (list 'rosalind rosalind)
            (list 'melissa melissa)
            (list 'maryann maryann)))))
    

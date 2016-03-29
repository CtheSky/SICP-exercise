(define (div-terms L1 L2)
    (if (empty-termlist? L1)
        (list (the-empty-termlist) (the-empty-termlist))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-termlist) L1)
              (let  ( (new-c (div (coeff t1) (coeff t2)))
                      (new-o (- (order t1) (order t2)))
                      (new-t (make-term new-o new-c))
                      (mult (mul-terms L2 (list new-t)))
                      (diff (add-terms 
                              L1
                              (negate-terms mult))))
                (let ((rest-of-result
                        (div-terms diff L2)))
                  (list 
                    (cons new-t (car rest-of-result))
                    (cadr rest-of-result))))))))
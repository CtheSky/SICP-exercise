;;a
(and (supervisor ?person (Ben Bitdiddle))
     (address ?person ?where))

;;b
(and (salary (Ben Bitdiddle) ?ben-salary)
     (salary ?person ?amount)
     (lisp-value < ?amount ?ben-salary))

;;
(and (job ?person ?job-info)
     (supervisor ?person ?boss)
     (not (job ?boss (computer . ?boss-job-info))))

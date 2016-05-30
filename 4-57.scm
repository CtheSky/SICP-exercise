(rule (can-replace ?person-1 ?person-2)
      (and (not (same ?person-1 ?person-2))
	   (or (and (job ?person-1 ?job) (job ?person-2 ?job))
	       (and (job ?person-1 ?job-1)
		    (job ?person-2 ?job-2)
		    (can-do-job ?job-1 ?job-2)))))

;;a
(can-replace ?person (fect cy d))

;;b
(and (salary ?person-1 ?salary-1)
     (salary ?person-2 ?salary-2)
     (lisp-value < ?salary-1 ?salary-2)
     (can-replace ?person-1 ?person-2))

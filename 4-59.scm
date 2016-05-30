;;a take Friday for example
(meeting ?dept (Friday . ?time))

;;b
(rule (meeting-time ?person ?day-and-time)
      (or (meeting whole-company ?day-and-time)
	  (and (meeting ?department ?day-and-time)
	       (job ?person (?department . ?rest)))))

;;c
(and (meeting-time (Hacker Alyssa P) (Wednesday . ?time))
     (meeting ?department (Wednesday . ?time)))

(rule (last-pair (?elem) (?elem)))

(rule (last-pair (?u . ?v) (?last))
      (last-pair ?v (?last)))

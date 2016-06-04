(rule ((great . ?rel) ?x ?y)
      (and (append-to-form ?head (grandson) ?rel)
	   (rel? ?x-son ?y)
	   (son ?x ?x-son)))

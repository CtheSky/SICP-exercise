(load "2-69.scm")
(load "2-68.scm")

(define song-pairs '((a 2) (na 16) (boom 1) (sha 3) (get 2) (job 2) (yip 9) (wah 1)))

(define song-tree 
	(generate-huffman-tree 
		'((a 2) (na 16) (boom 1) (sha 3) 
		  (get 2) (job 2) (yip 9) (wah 1))))

(define song-message '(get a job sha na na na na na na na na
					   get a job sha na na na na na na na na 
					   wah yip yip yip yip yip yip yip yip yip 
					   sha boom))

(define code (encode song-message song-tree))
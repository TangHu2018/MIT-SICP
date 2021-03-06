;;
;; Exercise 2.41
;;
;; Write a procedure to find all ordered triples of distinct positive integers
;; i, j, and k less than or equal to a given integer n that sum to a given 
;; integer s.
;;

;;
;; First let's import the "unique-pairs" procedure from Exercise 2.40 
;; (We'll name it the "ordered-pairs" procedure, for consistency).
;;
(define (ordered-pairs n)
  (accumulate append
	      '()
	      (map (lambda (i)
		     (map (lambda (j) (list i j))
			  (enumerate-interval 1 (- i 1))))
		   (enumerate-interval 1 n))))

;;
;; The supporting procedures we need to make this procedure work are:
;;
(define (enumerate-interval i j)
  (define (iter count total)
    (cond ((<= count j) (iter (+ count 1) (append total (list count))))
	  (else 
	   total)))
  (iter i '()))

(define (accumulate op initial sequence)
  (define (iter result rest)
    (if (null? rest)
	result
	(iter (op result (car rest))
	      (cdr rest))))
  (iter initial sequence))

;;
;; With the "ordered-pairs" procedure defined, we can define the following 
;; "helper" function which gives us the set of all ordered triples, where 
;; the "highest" (and "first") element is n:
;;
(define (ordered-triples-for-n n)
  (map (lambda (i) (append (list n) i)) (ordered-pairs (- n 1))))

;;
;; Note that it doesn't make sense to think of ordered triples of positive
;; integers less than 3:
;;
(ordered-triples-for-n 1)
;; ==> ()
(ordered-triples-for-n 2)
;; ==> ()
(ordered-triples-for-n 3)
;; ==> ((3 2 1))
(ordered-triples-for-n 4)
;; ==> ((4 2 1) (4 3 1) (4 3 2))

;;
;; Now we can finally define the "ordered-triples" procedure by accumulating
;; all the elements generated by the "ordered-triples-for-n" procedure:
;;
(define (ordered-triples n)
  (flatmap ordered-triples-for-n (eumerate-interval 1 n)))

;;
;; Run some tests:
;;
(ordered-triples 4)
;; ==> ((3 2 1) (4 2 1) (4 3 1) (4 3 2))
(ordered-triples 3)
;; ==> ((3 2 1))

;;
;; What we are seeking is all ordered triples, less than or equal to n, 
;; that sum to a given integer s.
;;
(define (target-sum n s)
  ;; Take an ordered triple as argument, and 
  ;; see whether it equals our target.
  (define (bulls-eye? seq)
    (if (= (length seq) 3)
	(= s (+ (car seq) (cadr seq) (caddr seq)))
	#f))

  ;; Implement the actual procedure.
  (filter bulls-eye? (ordered-triples n)))

;;
;; Run some tests:
;;
(target-sum 10 10)
;; ==> ((5 3 2) (5 4 1) (6 3 1) (7 2 1))
(target-sum 5 1)
;; ==> ()
(target-sum 5 7)
;; ==> ((4 2 1))
(target-sum 6 10)
;; ==> ((5 3 2) (5 4 1) (6 3 1))
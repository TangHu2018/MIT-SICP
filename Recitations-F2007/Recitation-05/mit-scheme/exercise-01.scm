;;
;; Exercise 1
;;
;; Draw box-and-pointer diagrams for the values of the following expressions. 
;; Also give the printed representation.
;;
;; (a) (cons 1 2)
;;
;; (b) (cons 1 (cons 3 (cons 5 '())))
;; 
;; (c) (cons (cons (cons 3 2) (cons 1 0)) '())
;;
;; (d) (cons 0 (list 1 2))
;;
;; (e) (list (cons 1 2) (list 4 5) 3)
;; 

;;
;; (a) (cons 1 2)
;;

     --- ---       --- 
--> | * | * | --> | 2 | 
     --- ---       --- 
      |
      v 
     --- 
    | 1 |
     ---       

(cons 1 2)
;; ==> (1 . 2)


;;
;; (b) (cons 1 (cons 3 (cons 5 '())))
;;

(cons 1 (cons 3 (cons 5 '())))
;; ==> (1 3 5)

;;
;; (c) (cons (cons (cons 3 2) (cons 1 0)) '())
;;

(cons (cons (cons 3 2) (cons 1 0)) '())
;; ==> (((3 . 2) 1 . 0))

;;
;; (d) (cons 0 (list 1 2))
;;

(cons 0 (list 1 2))
;; ==> (0 1 2)

;;
;; (e) (list (cons 1 2) (list 4 5) 3)
;;

(list (cons 1 2) (list 4 5) 3)
;; ==> ((1 . 2) (4 5) 3)
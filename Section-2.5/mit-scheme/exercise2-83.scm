;;
;; Exercise 2.83
;;
;; [WORKING]
;;

;;
;; Both the tower diagram and the problem statement refer to a type hierarchy 
;; something like the following:
;;
;;  integer --> rational --> real --> complex
;;
;; However, we have not hitherto generated "integer" and "real" packages, and, 
;; on the contrary, both "integer" and "real" types are handled uniformly by 
;; our "scheme-number" package. 
;;
;; Accordingly, we will define two hierarchies that looks something more like:
;;
;;       +------------------------------+
;;       |                              | 
;;       |                              v
;;  scheme-number <---> rational ---> complex
;;
;; Because of some of the "jumps" and "cycles" involved, this is possibly inviting
;; trouble, but we will be sure and try to test our use cases thoroughly to try 
;; and avoid any such problems.
;;


;;
;; The tower and the problem statement mention transforming rationals to reals, and 
;; reals to complex, but since we haven't added a "real" component 

;;
;; This method uses the "exact-integer?" procedure which is built into MIT Scheme:
;;
(define (raise-scheme-number->rational n)
  (if (exact-integer? n)
      (make-rational n 1)
      (raise-scheme-number->complex n)))

(define (raise-scheme-number->complex n)
  (make-complex-from-real-imag n 0.0))

;;
;; We can do without inserting this one in the table:
;;
(define (raise-rational->scheme-number r)
  (let ((n (numer r))
	(d (denom r)))
    (make-scheme-number (/ (* 1.0 n) (* 1.0 d)))))

(define (raise-rational->complex r)
  (let ((x (raise-rational->scheme-number r)))
    (make-complex-from-real-imag x 0.0)))



      (make-scheme-number n))) ;; <-- potential source of problems!!!


(define (raise-integer n)
  (make-rational n 1))

(define (raise-rational r)
  (let ((n (numer r))
	(d (denom r)))
    (/ (* 1.0 n) (* 1.0 d))))

(define (raise-real r)
  (make-complex-from-real-imag r 0.0))

(define (raise x) (apply-generic 'raise x))


(put 'raise '(integer)
     (lambda (x) (attach-tag 'rational (raise-integer x))))
(put 'raise '(rational)
     (lambda (x) (attach-tag 'real (raise-rational x))))
(put 'raise '(real)
     (lambda (x) (attach-tag 'complex (raise-real x))))
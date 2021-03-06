;;
;; Exercise 1.8
;;
;; Although not requested, I thought it's useful to have 
;; the sqrt code all together in one place.
;;

;; define the "square" form
(defun square (x) (* x x))

;;
;; Define interface to "sqrt-iter" procedure.
;;
(defun sqrt (x) (sqrt-iter 1.0 x))

;;
;; Define iterative procedure for arriving at square roots.
;;
(defun sqrt-iter (guess x)
  (if (good-enough? guess x)
      guess
    (sqrt-iter (improve guess x) x)))

;; 
;; Use the "new" method of approximation, based on fractional changes.
;;
(defun good-enough? (guess x)
  (defvar tolerance 0.001)
  (< (abs (- (/ (square guess) x) 1.0)) tolerance))

;;
;; Supporting procedures 
;;
(defun improve (guess x)
  (average guess (/ x guess)))

(defun average (x y)
  (/ (+ x y) 2.0))

;;
;; Run some unit tests:
;;
(sqrt 1)
;; ==> 1.0

(sqrt 2)
;; ==> 1.4142156862745097

(sqrt 3)
;; ==> 1.7321428571428572

(sqrt 4)
;; ==> 2.000609756097561
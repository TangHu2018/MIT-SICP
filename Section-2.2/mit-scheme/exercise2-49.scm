;;
;; Exercise 2.49
;;
;; {WORKING]
;;

;;
;; The supporting vector procedures are given here:
;;
(define (make-vect x y)
  (list x y))
(define (xcor-vect p)
  (car p))
(define (ycor-vect p)
  (cadr p))

(define (add-vect a b)
  (make-vect 
   (+ (xcor-vect a) (xcor-vect b))
   (+ (ycor-vect a) (ycor-vect b))))
(define (sub-vect a b)
  (make-vect
   (- (xcor-vect a) (xcor-vect b))
   (- (ycor-vect a) (ycor-vect b))))
(define (scale-vect c a)
  (make-vect
   (* c (xcor-vect a))
   (* c (ycor-vect a))))

;;
;; The "frame-coord-map" procedure is given as:
;;
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
			   (edge1-frame frame))
	       (scale-vect (ycor-vect v)
			   (edge2-frame frame))))))

;;
;; The "segments->painter" procedure is given as:
;;
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each 
     (lambda (segment)
       (draw-line
	((frame-coord-map frame) (start-segment segment))
	((frame-coord-map frame) (end-segment segment))))
     segment-list)))

;;
;; As indicated in the text, these procedures are designed to draw inside 
;; the unit square. If we are using Dr. Scheme to render the images, we need 
;; to substract a small "epsilon" from the edge to make sure it renders 
;; directly onto the screen, e.g., (define p2 (make-vect 0.99 0)).
;;
;; For the purposes of this discussio, we will simply use the more natural 
;; number representation:
;;
(define p1 (make-vect 0 0))
(define p2 (make-vect 1 0))
(define p3 (make-vect 1 1))
(define p4 (make-vect 0 1))

;; We'll draw the "diamond" by using our vector composition procedures:
(define p5 (scale-vect 0.5 (add-vect p1 p2)))
(define p6 (scale-vect 0.5 (add-vect p2 p3)))
(define p7 (scale-vect 0.5 (add-vect p3 p4)))
(define p8 (scale-vect 0.5 (add-vect p4 p1)))

(define s1 (make-segment p1 p2))
(define s2 (make-segment p2 p3))
(define s3 (make-segment p3 p4))
(define s4 (make-segment p4 p1))

(define s5 (make-segment p1 p3))
(define s6 (make-segment p2 p4))

(define s7 (make-segment p5 p6))
(define s8 (make-segment p6 p7))
(define s9 (make-segment p7 p8))
(define s10 (make-segment p5 p5))

;; (a) The painter that draws the outline of the designated frame:
(define painter1 (segments->painter (list s1 s2 s3 s4)))

;; (b) The painter that draws an "X" by connecting opposite corners of the frame:
(define painter2 (segments->painter (list s5 s6)))

;; (c) The painter that draws a diamond shape by connecting the midpoints of the sides of the frame:
(define painter3 (segments->painter (list s7 s8 s9 s10)))

;; [WORKING]
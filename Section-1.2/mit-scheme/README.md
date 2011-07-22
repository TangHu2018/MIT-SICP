Section 1.2
=========== 

Recursive and Iterative Processes
--------------------------------- 

A recursively-defined procedure need not generate a recursive process.

However, most implementations of common languages (including Ada, Pascal and C) are designed in such a way that the interpretation of any recursive procedure consumes an amount of memory that grows with the number of procedure calls, even when the process described is, in principle, iterative. As a consequence, these languages can describe iterative processes only by resorting to special-purpose "looping constructs" such as `do`, `repeat`, `until`, `for` and `while`. Most Lisp implementations, on the other, do not share this defect: they will execute an iterative process in constant space, even if the iterative process is described by a recursive procedure. An implementation with this property is called **tail-recursive**.

A recursive process is usually easier to define and conceptualize than an iterative process, although it will generally consume more time and space during execution. Recursive processes also suffer from the defect that part of the state, used to define the proess, must be stored in "hidden variables" maintained in the environment settings. Accordingly, it is more difficult to stop and restart a recursive process midway through execution. An iterative process, on the other hand, is completely defined by a small number of state variables, and can be stopped and restarted arbitarily so long as these state variables are saved.

Exponentiation
-------------- 

We can define a **recursive procedure** which generates a **recursive process** to model exponentiation:

<pre>
(define (expt b n)
 (if (= n 0)
     1
     (* b (expt b (- n 1)))))
</pre>

The call graph for `(expt 3 5)` will look something like the following:

<pre>
(expt 3 5)
(* 3 (expt 3 4))
(* 3 (* 3 (expt 3 3)))
(* 3 (* 3 (* 3 (expt 3 2))))
(* 3 (* 3 (* 3 (* 3 (expt 3 1)))))
(* 3 (* 3 (* 3 (* 3 (* 3 (expt 3 0))))))
(* 3 (* 3 (* 3 (* 3 (* 3 1)))))
(* 3 (* 3 (* 3 (* 3 3))))
(* 3 (* 3 (* 3 9)))
(* 3 (* 3 27))
(* 3 81)
243
</pre>

This is a linear recursive process which requires O(n) steps and O(n) space.

We can also model exponentiation by defining a **recursive procedure** which generates an **iterative process**:

<pre>
(define (expt b n)
 (expt-iter b n 1))

(define (expt-iter b n a)
 (if (= n 0)
     a
     (expt-iter b (- n 1) (* b a))))
</pre>

The call graph for `(expt 3 5)` will in this case look something like:

<pre>
(expt 3 5)
(expt-iter 3 5 1)
(expt-iter 3 4 3)
(expt-iter 3 3 9)
(expt-iter 3 2 27)
(expt-iter 3 1 81)
(expt-iter 3 0 243)
243
</pre>

This version requires O(n) steps but only O(1) space.

There are techniques we can use to get higher performance out of our procedures. 

One such technique is called "successive squaring". A recursively-defined procedure, which uses successive squaring to generate a **recursive process** for calculating exponentials, is demonstrated below:

<pre>
(define (fast-expt b n)
 (cond ((= n 0) 1)
       ((even? n) (square (fast-expt b (/ n 2))))
       (else 
        (* b (fast-expt b (- n 1))))))

(define (even? n) (= (remainder n 2) 0))
(define (square n) (* n n))
</pre>

The call graph for `(fast-expt 3 100)` is:

<pre>
(fast-expt 3 100)
(square (fast-expt 3 50))
(square (square (fast-expt 3 25)))
(square (square (* 3 (fast-expt 3 24))))
(square (square (* 3 (square (fast-expt 3 12)))))
(square (square (* 3 (square (square (fast-expt 3 6))))))
(square (square (* 3 (square (square (square (fast-expt 3 3)))))))
(square (square (* 3 (square (square (square (* 3 (fast-expt 3 2))))))))
(square (square (* 3 (square (square (square (* 3 (square (fast-expt 3 1)))))))))
(square (square (* 3 (square (square (square (* 3 (square (* 3 (fast-expt 3 0))))))))))
(square (square (* 3 (square (square (square (* 3 (square (* 3 1)))))))))
(square (square (* 3 (square (square (square (* 3 (square 3))))))
(square (square (* 3 (square (square (square (* 3 9)))))))
(square (square (* 3 (square (square (square 27))))))
(square (square (* 3 (square (square 729)))))
(square (square (* 3 (square 531441))))
(square (square (* 3 282429536481)))
(square (square 847288609443))
(square 717897987691852588770249)
515377520732011331036461129765621272702107522001
</pre>

Evaluation of `(fast-expt 3 100)` only performs 9 multiplications, where `(expt 3 100)` would perform 100. 

The procedure grows as O(log(n)), and for large n is dramatically more efficient than the naive recursive implementation of `expt` given at the start of this section.

It is also possible to implement `fast-expt` so that it generates an **iterative process**:

<pre>
(define (fast-expt b n)
 (fast-expt-iter b n 1))

(define (fast-expt b n a)
 (cond ((= n 0) a)
       ((even? n) (fast-expt-iter (square b) (/ n 2) a))
       (else
         (fast-expt-iter b (- n 1) (* a b)))))
</pre>

In this case, the call graph for `(fast-expt 3 100)` looks like:

<pre>
(fast-expt 3 100)
(fast-expt-iter 3 100 1)
(fast-expt-iter 9 50 1)
(fast-expt-iter 81 25 1)
(fast-expt-iter 81 24 81)
(fast-expt-iter 6561 12 81)
(fast-expt-iter 43046721 6 81)
(fast-expt-iter 1853020188851841 3 81)
(fast-expt-iter 1853020188551841 2 150094635296999121)
(fast-expt-iter 3433683820292512484657849089281 1 150094635296999121)
(fast-expt-iter 3433683820292512484657849089281 0 515377520732011331036461129765621272702107522001)
515377520732011331036461129765621272702107522001
</pre>

Arithmetical Operations
----------------------- 

One of the more profound aspects of Lisp/Scheme is that arithmetical operators are themselves functions which can be re-defined to suit various needs.

For example, one could (rather perversely) redefine '+' to behave like:

<pre>
(+ 3 5)
;; 8

(define (+ a b) (* a (* 2 b)))
(+ 3 5)
;; 30
</pre>

Or perhaps more conveniently:

<pre>
(define div /)
(define (/ a b)
 (if (= b 0)
     'false
     (div a b)))

(/ 5 0)
;; --> false
</pre>

Or an even more informative error handling condition:

<pre>
(define div /)
(define (/ a b)
 (if (= b 0)
     (display "*** cannot divide by zero!")
     (div a b)))

(/ 5 0)
;; --> *** cannot divide by zero!
</pre>

Call Graphs
-----------

The global behavior of a computational process can, in part, be visualized by modeling the call graph generated by the procedure. 

The Fibonacci sequence is a canonical example of a procedure that can be used to generate a tree recursive computational process. The following call graph illustrates evaluation of `(fib 10)`, and the tree recursive graph structure that it generates. Entry into the procedure at `(fib 10)` is indicated by the red node. Purple nodes represent branch points, while the green nodes indicate calls where the recursion "bottoms out" at either `(fib 1)` or `(fib 0)`.

[![](http://farm7.static.flickr.com/6037/5906890656_7acd67125e.jpg)](http://farm7.static.flickr.com/6037/5906890656_7acd67125e.jpg)

[*Generated by Ubigraph*](http://ubietylab.net/ubigraph/)

We can get a more "quantitative" feel for the call graph by expanding it in a more traditional format. Although the call graph for `(fib 10)` would be too tedious to expand in this way here, the following diagram illustrates a more quantitative representation for the call graph of `(fib 5)`:

[![](http://farm6.static.flickr.com/5151/5909855256_588deed1a1.jpg)](http://farm6.static.flickr.com/5151/5909855256_588deed1a1.jpg)

[*Generated by GraphViz*](http://www.graphviz.org/)
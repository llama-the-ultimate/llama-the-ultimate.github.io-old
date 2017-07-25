#lang at-exp racket
(provide lamb-data-note)
(require "structs.rkt"
         "util.rkt")

(deftxt n @em{n})
(deftxt + @tt{+})
(deftxt a @tt{a})
(deftxt b @tt{b})
(deftxt f @tt{f})
(deftxt x @tt{x})

(define lamb-data-note
  (lambs-nt
   'lamb-data
   "Some data structures"
   #f
      
   @p{
 A bit of prelude. Some stuff from an earlier @nlnk['lamb-nums]{numbery post}:
}
   
   @lambs[10 #:prelude #t]{
 0 ≜ λf.λx.x
 1 ≜ λf.λx.f x
 2 ≜ λf.λx.f (f x)
 5 ≜ λf.λx.f (f (f (f (f x))))
 + ≜ λa.λb.λf.λx.a f (b f x)
}
   @p{
 (And in the earlier post we said something like:
 The number @n is a function that,
 if given two arguments,
 applies the first argument @n times to the second.
 The @(+)-function takes the numbers @a and @b as arguments
 and gives back a new @ttc{λf.λx}-function that applies @f @q{@a times}
 to the result of applying @f @q{@b times} to @(x).)
}
   @p{
 We can do like multiuplication as well, before moving on.
 Multiplication is like addition, just more.
 We will make a function that given the numbers @a and @b as arguments,
 will like, start with the number zero, and add @a @q{@b times} to it:
}
   @lambs[8]{
 * ≜ λa.λb.b (+ a) 0

 * 5 2
}

   
   ))
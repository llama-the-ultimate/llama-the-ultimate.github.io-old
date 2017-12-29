#lang at-exp racket
(provide lamb-succ-note)
(require "structs.rkt"
         "util.rkt")

(deftxt n @tt{n})
(deftxt f @tt{f})
(deftxt x @tt{x})
(deftxt S @tt{S})
(deftxt Z @tt{0})

(define lamb-succ-note
  (lambs-nt
   'lamb-succ
   "Successor"
   (date 2017 12 29)
   @p{
 We have made some numbers and some functions for working with numbers. Also some other datatypes.
}
   @p{
 We haven’t really done so here,
 but sometimes when we define numbers we fuss more about how they are constructed,
 about what the constructors are.
 We say things like: @q{A natural number is zero or it is the successor of a natural number.}
 (In a Standard ML we might say: @ttc{datatype nat = Zero | Succ of nat}.)
}
   @p{
 So let’s try to? With the lambdas and such...
}
   @brk
   @p{
 We already know what zero looks like:
}
   @lambs[3]{
 0 ≜ λf.λx.x
}
   @p{
 We do not know that successor looks like:
}

   @lambs[3]{
 S ≜ λn.λf.λx.f (n f x)
}
   @p{
 It takes a number, @n, as its argument.
 @S applied to @n should return a number that is one larger than @(n).
}
   @p{
 (Remember: @numberdef)
}
   @p{
 So, @tt{S} takes a number, @n, as its argument, and returns one of those @ttc{λf.λx.}-functions.
 Within, we do @ttc{(n f x)}; we apply @n to @f and @(x). This should amount to applying @f @q{@n times} to @(x).
 And then we apply @f to the result of @ttc{(n f x)},
 so that we should, in total, get @f applied, well, @q{@(n)+1 times} to @(x).
}
   @p{
 We can test it some and see if it looks right:
}
   @lambs[15]{
 S 0

 S (S 0)
 
 S (S (S 0))

 S (S (S (S (S 0))))
}
   
   @brk
   @p{
 And like, that’s it, that’s our successor.
 It seems maybe less impressive than the addition and multiplcation functions we did earlier.
 But like it’s pretty cool:
}
   (ul
    @li{We have zero-and-successor constructors. Much like the grown-ups have.}
    @li{
 We can, somewhat obviously, build any natural number with @Z and @(S).
 Like, we have @Z, and we can totally just throw @(S)es at it until we have the number we really want.
}
    @li{
 Related: We kind of don’t really have to write the @ttc{λf.λx.}-bit ever again. Unless we want to.
 Like, if we’re defining addition, say, and we stick to @Z and @S,
 we won’t have to do the @ttc{λf.λx.}-bit in order to construct the result-number.
}
    )
   @p{
 Will take a look at that last ting. But like, in later post...
}
   ))
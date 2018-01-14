#lang at-exp racket
(provide lamb-design-pattern-note)
(require "structs.rkt"
         "util.rkt")

(deftxt S @tt{S})
(deftxt Z @tt{0})
(deftxt two @tt{2})
(deftxt three @tt{3})


(deftxt foo @tt{foo})
(deftxt bar @tt{bar})

(define lamb-design-pattern-note
  (lambs-nt
   'lamb-design-pattern
   "A design pattern?"
   (date 2018 01 14)
      
   @p{
 @nlnk['lamb-succ]{Previously} we constructored:
}
   
   @lambs[5 #:prelude #t]{
 0 ≜ λf.λx.x

 S ≜ λn.λf.λx.f (n f x)
}
   @p{
 Now there are some things. Or, this possibly encourages a way of thinking about some things.
}
   @p{
 One thing is: We can think that any natural number must necessarily be built from @Z and a series of @(S)es.
 (And if we’d like, we can think about the types of things, and argue that @ttc{0 : nat} and @ttc{S : nat -> nat}.)
}
   @p{
 Another thing is: A number like this is a function. And that function kind of is the @q{eliminator function} for that number.
 An @q{eliminator function} like this is rather similar to the @nlnk['foldr]{foldr}-function for lists;
 we can think of it as a function for doing @q{constructor replacement.}
}
   @p{
 Like if we have a number built from @ttc{S (S 0)}, and we wanna replace the @(S)es with @tt{foo}s and the @Z with @tt{bar},
 we can apply the number to @tt{foo} and @tt{bar}:
}
   @lambs[9]{
 (S (S 0)) foo bar
}
   @brk
   @p{
 So, say we have the numbers @two and @(three)...
}
   @lambs[10]{
 S (S 0)
 
 S (S (S 0))
}
   @p{
 Reduced to normal form:
}
   @lambs[5]{
 2 ≜ λf.λx.f (f x)
 
 3 ≜ λf.λx.f (f (f x))
}
   @p{
 And, say we want to add them together.
 If we want the sum, we can take the number @(two) and do the @q{constructor replacement} thing.
 The number @two is built from the @(Z)-constructor and 2 @(S)-contructors: @ttc{S (S 0)}.
 We should be able to get sum by taking that number and, keeping all the @(S)es, replacing the @Z with @(three):
 @ttc{S (S 3)}, which should amount to like 5.
}
   @p{
 We try. Taking the number @two, we replace @S with @S, which should let us @q{keep} all the @(S)es,
 and we replace @Z with @(three):
}
   @lambs[10]{
 2 S 3
}
   @p{
 We get 5 :)
}
   @p{
 A bit of abstraction and we will have a @tt{+}-function.
}
   @lambs[10]{
 + ≜ λa.λb.a S b

 + 2 3
}
   @brk
   @p{
 Or, say we want to multiply @two by @(three).
}
   @p{
 This time the idea is that we want to replace things so that we turn the number @two, or @ttc{S (S 0)},
 into @ttc{+ 3 (+ 3 0)}.
 We replace the @(S)es with a function that adds 3 to something, and we replace @Z with @(Z):
}
   @lambs[10]{
 2 (+ 3) 0
}
   @p{
 6!
}
   
   @p{
 Again, abstraction:
}
   @lambs[10]{
 * ≜ λa.λb.a (+ b) 0

 * 2 3
}  
   @brk
   @p{
 (So, uh. In my experience, thinking about these things in terms of constructors and constructor replacement
 lets me look away from the @q{inner workings} of the numbers a little bit,
 and also make the things feel slightly more like working with datatypes in e.g. an ML dialect.
 It sometimes makes some things clearer to me.
 But like, we totally did do @nlnk['lamb-nums]{addition} and @nlnk['lamb-bools]{multiplication} earlier,
 and it’s not like the functions we did here are very different from those earlier ones. Just a little different.)
}
   ))
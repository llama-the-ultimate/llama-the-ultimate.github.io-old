#lang at-exp racket
(provide lamb-pairs-note)
(require "structs.rkt"
         "util.rkt")

(deftxt f @tt{f})
(deftxt a @tt{a})
(deftxt b @tt{b})
(deftxt foobarpair @tt{foobarpair})

(deftxt foo @tt{foo})
(deftxt bar @tt{bar})

(define lamb-pairs-note
  (lambs-nt
   'lamb-pairs
   "Pairs"
   (date 2017 7 30)
      
   @p{
 Prelude. Some things we defined in earlier posts:
}
   
   @lambs[10 #:prelude #t]{
 0 ≜ λf.λx.x
 1 ≜ λf.λx.f x
 2 ≜ λf.λx.f (f x)
 + ≜ λa.λb.λf.λx.a f (b f x)
 * ≜ λa.λb.b (+ a) 0
}
   @p{
 We wanna make some 2-tuples, or pairs.
 Pairs are good for building things and we’re going to need them to build a thing reasonably soon.
}

   @p{
 A pair is a @q{finite ordered list} of two elements. It’s a thing with two things.
 Since it can’t not be, a pair is going to be a function.
 The way we’re going to use a pair is we’re going to apply it to an argument (since that is how functions are used).
 And then that argument must somehow get access to the two elements that the pair is holding on to.
 The argument given to the pair will necessarily also be function.
}

   @p{
 So: A pair should be a function that, given one function as an argument,
 gives its two elements to that argument-function.
 A pair with the elements @foo and @bar, then, should look like this:
}
   @lambs[3]{
 foobarpair ≜ λf.f foo bar
}
   @p{
 If we give the pair an argument, that argument will go in the place of the @f in @ttc{f foo bar}, and then @foo and @bar will be given to it:
}
   @lambs[5]{
 foobarpair (λa.λb.a b quux)
}
   @p{
 That is, @ttc{λa.λb.a b quux} is given @foo and @bar as arguments from the @foobarpair,
 so in the body @ttc{a b quux}, @a and @b are replaced with @foo and @(bar).
 We can access the elements of a pair by accessing @a and @b within some @ttc{λa.λb.}-function that we apply the pair to.
}
   
   @p{
 So it looks like we have a pair that kind of works.
 We sometimes want other pairs than the @foo and @bar one, so we will build like a constructor-function.
 A constructor for pairs will be a function that takes two arguments, and returns something along the lines of that @ttc{λf.f foo bar}-function.
 Only instead of @foo and @bar, we should use the two arguments we got.
}
   @lambs[10]{
 pair ≜ λa.λb.λf.f a b

 (pair foo bar) (λa.λb.a b quux)
 
 (pair far boo) (λa.λb.a b quux)
}
   @p{
 And that’s really everything we need.
 But if we want to, for convenience like, we can make a couple of @q{getter}-functions.
 We can get the first element of a pair by applying it to a two-argument function that returns its first argument:
}
   @lambs[5]{
 foobarpair (λa.λb.a)
}
   @p{
 We will make a @tt{fst}-function that will do that, but with some pair given as an argument instead of with the @(foobarpair).
 And a @tt{snd}-function that does the same as @tt{fst}, only it will use a function that returns its second argument.
}

   @lambs[10]{
 fst ≜ λp.p (λa.λb.a)
 snd ≜ λp.p (λa.λb.b)

 fst foobarpair
 
 snd foobarpair
}

   @p{
 And so we have more than we need for useful things.
 We can make a function that takes a number as an argument and like, doubles the number and squares the number, and returns a pair with the two result-numbers.
 And a function that takes a pair of numbers and adds those two numbers together.
}
   @lambs[20]{
 useful-thing1 ≜ λn.pair (+ n n) (* n n)
 useful-thing2 ≜ λp.+ (fst p) (snd p)
 compose ≜ λf.λg.λx.f (g x)
 useful-things ≜ compose useful-thing2 useful-thing1
 
 useful-things (+ 1 2)
}
   @p{
 Woop.
}
   ))
#lang at-exp racket
(provide lamb-bools-note)
(require "structs.rkt"
         "util.rkt")

(deftxt n @em{n})
(deftxt + @tt{+})
(deftxt a @tt{a})
(deftxt b @tt{b})
(deftxt f @tt{f})
(deftxt x @tt{x})

(deftxt true @tt{true})
(deftxt false @tt{false})
(deftxt stuff @tt{stuff})
(deftxt otherstuff @tt{otherstuff})
(deftxt not @tt{not})
(deftxt and @tt{and})
(deftxt or @tt{or})

(define lamb-bools-note
  (lambs-nt
   'lamb-bools
   "Some booly functions"
   (date 2017 7 27)
      
   @p{
 Bit of prelude, first. Some stuff from an earlier @nlnk['lamb-nums]{numbery post}:
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
 We will make a function that, if given the numbers @a and @b as arguments,
 will like, start with the number zero, and add @a @q{@b times} to it:
}
   @lambs[10]{
 * ≜ λa.λb.b (+ a) 0

 * 5 2
}
   @brk
   @p{
 Soo. We have several numbers and also a couple of ways to make more numbers.
 So we pretty much have business:
 We can decide that one of the numbers is the number of monies and another one is the number of products.
 If we also have booleans we can do business logic.
}
   @p{
 Booleans are used for if-then-else.
 We have a stuff we maybe wanna do and another stuff we maybe wanna do instead, and we use a boolean to pick one of the stuffs.
 So, we would like to have a @(true)-value and a @(false)-value,
 and we wanna set things up so that something like @ttc{if true stuff otherstuff} will evaluate to @stuff,
 and something like @ttc{if false stuff otherstuff} will evalute to @(otherstuff).
}
   @p{
 We will make the two boolean values be functions. (A reasonably easy choice, so long as we can only make functions in our language.)
 @true will, if given two arguments, return the first one. @false, if given two arguments, will return the second one.
}

   @lambs[10]{
 true ≜ λa.λb.a
 false ≜ λa.λb.b

 true stuff otherstuff

 false stuff otherstuff
}

   @p{
 Okay so it looks like @ttc{true stuff otherstuff} evaluates to @stuff just fine on it’s own,
 and @ttc{false stuff otherstuff} evaluates to @otherstuff,
 and we don’t really need @tt{if}.
 But like if we want an @tt{if} we can have one.
 It can take a boolean as its first arguments and then two more arguments,
 and then like, just, hand those two last arguments over to the boolean.
}

   @lambs[10]{
 if ≜ λb.λt.λe.b t e

 if true stuff otherstuff

 if false stuff otherstuff
}
   @p{
 Should get same results as with just the booleans.
 (And if we want to, we can redefine @tt{if} to be the identity function, @ttc{λx.x}.
 Will work fine.
 The @ttc{if true} part of @ttc{if true stuff otherstuff} wil evaluate to @(true).
 So we get @ttc{true stuff otherstuff}, which we already know that works.)
}
   @brk
   @p{
 Okay, some boolean logic bits:
}
   (ul
    @li{@not takes one boolean @(b). If @b is @true, @not returns @(false). If @(b) is @false, @not returns @(true).}
    @li{@and takes two booleans @a and @(b). If @a is @true, @and returns @(b). If @a is @false, @and returns @(false).}
    @li{@or takes two booleans @a and @(b). If @a is @true, @or returns @(true). If @a is @false, @or returns @(b).})
   
   @lambs[10]{
 not ≜ λb.if b false true
 and ≜ λa.λb.if a b false
 or ≜ λa.λb.if a true b

 if (and (or true false) (not false)) stuff otherstuff
}
   @brk
   @p{
 We’ll do some boolean stuff with numbers.
 We can check if a number is zero by giving it two arguments.
 The first argument is a function that always returns @(false): @ttc{λ_.false}.
 If the number is not zero this function will be applied to something and we’ll get @false back.
 The second argument is @(true).
 If the number is zero this @true will be returned, without any applying of the @ttc{λ_.false}-function.
}

   @lambs[10]{
 zero? ≜ λn.n (λ_.false) true

 zero? 0
 
 zero? 2
}
   @p{
 Good. Now we can do everyday business logic things.
 Like you know when boss is like hey we need a program that checks if the number of monies times the number of products is zero
 and if it is zero we should add five to the number of monies and if it is not zero we should multiply the number of products by 2.
 And like, @em{no problem}.
}

   @lambs[20]{
 do-business ≜ λmonies.λproducts.if (zero? (* monies products)) (+ 2 monies) (* 2 products)

 do-business 2 5
 
 do-business 2 0
}
   @p{
 That’s a lot of business.
}
   @brk
   @p{
 (Oh. If we cared about side effects or maybe performance or something,
 we would maybe worry about stuff like: Will the else-stuff be evaluated even if the boolean is @true and we really only want the then-stuff?
 We don’t really care, since it’s going to correctly return the stuff we want either way.
 But like, @em{if} we cared:
 We’re evaluating things in normal order, and will give the then-stuff and the else-stuff to the boolean first, before we @q{step into} any of the then-stuff or else-stuff.
 So like in the case of @true the else-stuff will disappear before we do anything with it.)
}  
   ))
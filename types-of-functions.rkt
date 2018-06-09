#lang at-exp racket
(provide types-of-functions-note)
(require "structs.rkt")

(define types-of-functions-note
  (nt 'types-of-functions
      "Types of functions"
      (date 2018 6 9)
      @p{
 Blah. So like functions are nice and for me they are often a useful way to think about programs.
}
      @p{
 And then, for me, types more or less come with the territory.
 A function applied to an argument can be evaluated to a result value.
 When I think about a function, I tend to think about things like:
}
      @(ul @li{What do arguments I can apply this to look like?}
           @li{Which expressions are likely to evaluate to things I can use as arguments?}
           @li{What will results I get from applying the function look like?}
           @li{Where can I use such results?})
      
      @p{
 And that is like, type stuff, far as I can tell.
}
      @p{
 (Which is not to say that the thinking is necessarily in terms of a type @em{system},
 or that any of this has a thing to do with type @em{checking}, or anything.
 Just, types, okay yes.)
}
      ))

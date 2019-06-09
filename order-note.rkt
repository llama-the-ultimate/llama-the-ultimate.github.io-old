#lang at-exp racket
(require "structs.rkt")

(provide order-note)

(define order-note
  (nt 'order
      "Land of some other order"
      (date 2019 6 9)
      @p{
 We start with
 @ttl{#lang racket}
 or
 @ttl{#lang lazy}
}

      @p{
 And make some natural numbers and also one maybe unnatural.
}
      @block{
 (struct zero () #:transparent)
 (struct succ (pred) #:transparent)

 (define one (succ (zero)))
 (define two (succ one))
 (define (inf) (succ (inf)))
}
      @p{
 And a less-than-or-equal-to function.
}
      @block{
 (define (<= a b)
   (cond 
     [(zero? a) #t]
     [(zero? b) #f]
     [else (<= (succ-pred a) (succ-pred b))]))
}

      @p{
 (@tt{<=} is a function with parameters @tt{a} and @tt{b}:
 If @tt{a} is zero then true else if @tt{b} is zero then false
 else try with one-less-than-@tt{a} and one-less-than-@tt{b} instead.)
}
      @p{
 Okay. We can try to apply the function to some arguments.
 The following are are fine and evaluate to @tt{#t} and @tt{#f}.
}
      @block{
 (<= one two)
}
      @block{
 (<= two one)
}
      @p{
 If we started with @ttc{#lang racket} the next two will run forever and we won’t get values back.
 If we started with @ttc{#lang lazy} they’re fine and evaluate to @tt{#t} and @tt{#f}.
}
      @block{
 (<= two (inf))
}
      @block{
 (<= (inf) two)
}
            @p{
 The last one will run forever in both @ttc{#lang racket} and @ttc{#lang lazy}.
}
      @block{
 (<= (inf) (inf))
}
      @p{(Forever means until we are out of memory or something.)}

      @p{
 Anyway. We can like choose.
}
 (ul
  @li{If we want as many expressions as possible to give back values, we might prefer @ttc{#lang lazy}.}
  @li{If we want as many applications of @tt{<=} to give back values, we might prefer @ttc{#lang racket}.})
 
 @p{
 (In @ttc{#lang racket} the forever happens when evaluating the @tt{(inf)}-arguments @em{before} the @tt{<=}-function is applied.
 In @ttc{#lang lazy} we might have to decide: Is it the @tt{(inf)} or the @tt{<=} that causes forever?
 Is it reasonably to expect there to be a @tt{zero?} base case?)
}
 @brk
 @p{
 (Mlep. Code @lnk["https://gist.github.com/Glorp/979b7c23b7e650f45fb7372671bc5f8c"]{here}.
 We could have used like some Standard ML code and some Haskell code or something instead.
 Just, handy to use @q{the same} code for both versions and only switch between the two @tt{#lang}s.
 And then also we are not writing Racket code exactly the way we normally would, but like,
 sticking to reasonably basic stuff andalso stuff that works
 in both @ttc{#lang racket} and @ttc{#lang lazy}.)
}
 ))



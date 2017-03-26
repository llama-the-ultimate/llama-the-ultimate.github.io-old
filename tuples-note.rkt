#lang at-exp racket
(provide tuples-note)
(require "structs.rkt")

(define tuples-note
  (nt 'tuples
      "I like tuples"
      (date #f #f #f)
      @p{
 In a language where a function is a thing that takes one value as argument and returns one value as result, we tend to need @em{stuff} when we want to make a function that @q{takes multiple arguments.}
 One way of going about it is to use a tuple to group several values into like one large value, and then pass that value to our function.
 Another way is to do like currying, and make a function that takes the first argument and returns a function that takes the second argument and so on. Woop woop.
 }

      @p{
 In Standard ML we can do the tuples thing like so:
 }
      @block{
 - fun foo (a, b, c) = a + b + c;
 val foo = fn : int * int * int -> int
}
      @p{
 Or curried thing like so:
}
      @block{
 - fun bar a b c = a + b + c;
 val bar = fn : int -> int -> int -> int
}
      @p{
 Bla bla bla. Anyway. Few things I kind of like about tuples:
}
      @p{
 (I think they’re all the same ting really. And that that thing is that a tuple is a value.)
}
      brk
      @p{
 We can tuple together multiple return-values much like we can tuple together multiple argument-values. It works rather directly the same way.
}
@block{
 - fun triple a = (a, a, a);
 val triple = fn : 'a -> 'a * 'a * 'a
}
@p{
 (I’m not certain what would be the more @q{currying-like} way to deal with return-values. Maybe returning Church-encoded tuples I dunno.)
}
          @p{
 If we have some function that we don’t know a ton of stuff about, like maybe one we took as an argument or something, then it’s maybe easier to not care about how many arguments @em{it} takes.
 If there are multiple, they’re going to be all tupled up into just one value anyway, and we won’t have to do stuff like passing one argument to the function and another one to the function that is returned.
 Things like composing things seems to work out less awkwardly at times:
}
          @block{
 - Int.toString o foo o triple;
 val it = fn : int -> string
}
          @p{
 (If we tried to do the same, but with @tt{bar} instead of @tt{foo}, the compose-function, @tt{o}, would pretty unable to pass the result of @tt{triple} into @tt{bar}, or the result of @tt{bar} into @tt{Int.toString}. Since @tt{bar} returns an @ttc{int -> int -> int} rather than just an @tt{int}, and so on.)
}
          brk
          @p{
 Seems like it’s more straightforward to do like a decent error message for @q{wrong number of arguments} to a function if they’re in an argument-tuple.
}
          @p{
 @ttc{foo (1, 2)} gives some error message about how @ttc{int * int} doesn’t match up with @ttc{int * int * int}.
}
          @p{
 @ttc{bar 1 2} seems to work fine, but we’re left with an @ttc{int -> int} instead of just an @tt{int}. Typically leads to error sometime elsewhere.
}
      ))



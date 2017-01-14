#lang at-exp racket
(provide data-note)
(require "structs.rkt")

(define data-note
  (nt 'something-data
      "Something about data, values"
      "bla bla data something"
      @p{
 @lnk["https://mitpress.mit.edu/books/little-mler"]{The Little MLer} is a pretty fun book.
 There’s a lot of Standard ML code in it and Standard ML code has a lot of @tt{fun} in it.
}
      @p{
 Anyway there’s this theme in the book. We define a bunch of datatypes, and we define functions on them.
 And as the datatypes become more complicated and sophisticated, then, kind of @q{naturally,} so do the functions.
}

      @p{
 Like, we can introduce a recursive type, like one for natural numbers:
}

      @block{
 datatype natural =
     Zero
   | Successor of natural
}
      @p{
 And then when we wanna do stuff with the numbers, we kind of necessarily get recursive functions, like:
 }
      @block{
 fun add (a, b) =
     case a of
         Zero => b
       | Successor x => Successor (add (x, b))
}
      @p{
 (And so something like @tt{add (Successor (Successor Zero), Successor Zero)} evaluates to something like @tt{Successor (Successor (Successor Zero))}. Woop woop.)
}
      @p{
 Stuff like that. A type with more constructors typically leads to pattern matching with more patterns. Mutually recursive types lead to mutually recursive functions. …
}
      brk
      @p{
 (I guess this is at least pretty close to the idea of types being defined by their introduction and elimination rules, and the computational building blocks of a language being those rules.
 Every bit of behaviour being constructing and destructing of values.)
}
      brk
      @p{
 So, I think that suggests a way of doing things where you make sure the values you’re dealing with support the behaviour you’re aiming for.
 And then you can kind of tell that things are might be on the right track if the structure of the values show up in the structure of the functions.
}
      @p{
 (Perhaps as an alternative to a way of doing things where you have some strings and booleans more like, lying around, and, like, make do.)
}
      ))

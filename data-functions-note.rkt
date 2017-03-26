#lang at-exp racket
(provide data-functions-note)
(require "structs.rkt")

(define data-functions-note
  (nt 'data-functions
      "Data with functions on top"
      (date #f #f #f)
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
   | Succ of natural
}
      @p{
 And then when we wanna do stuff with the numbers, we kind of necessarily get recursive functions, like:
 }
      @block{
 fun add (a, b) =
     case a of
         Zero => b
       | Succ x => Succ (add (x, b))
}
      @p{
 (And so:
}
      @block{
 - add (Succ (Succ Zero), Succ Zero);
 val it = Succ (Succ (Succ Zero)) : natural
}
      @p{
 Woop woop.)
}
      @p{
 Stuff like that. A type with more constructors typically leads to pattern matching with more patterns. Mutually recursive types lead to mutually recursive functions. …
}
      brk
      @p{
 (Which is totes a thing also expressed elsewhere. It’s sometimes approached from the opposite direction. Always with less whim.)
}
      @p{
 (On the more type theoretic/beautiful side, it is not too far away from the idea of types being defined by their introduction and elimination rules, and the computational building blocks of a language being those rules.
 Every bit of behaviour being constructing and destructing of values.)
}
      brk
      @p{
 So, uh. Software Engineering! I think a pretty common thing is that things start falling apart when we have like very sophisticated behaviour, built on top of not so sophisticated data structures.
}
      ))

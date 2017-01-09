#lang at-exp racket
(provide data-note)
(require "structs.rkt")

(define data-note
  (nt 'something-data
      "Something about data"
      "bla bla data something"
      @p{
 @lnk["https://mitpress.mit.edu/books/little-mler"]{The Little MLer} is a pretty fun book.
 There’s a lot of Standard ML-code in it and Standard ML code has a lot of @tt{fun} in it.
}
      @p{
 Anyway there’s this theme in the book. We define a bunch of datatypes, and we define functions on them.
 And as the datatypes become more complicated and sophisticated, then, kind of @q{naturally,} so do the functions.
}

      @p{
 Like, we introduce a recursive type, like one for natural numbers. Something along the lines of,
}

      @block{
 datatype natural =
     Zero
   | Successor of natural
}
      @p{
 and then when we wanna do stuff with them, we kind of necessarily get recursive functions,
 }
      @block{
 fun add (a, b) =
     case a of
         Zero => b
       | Successor x => Successor (add (x, b))
}
      @p{
 and so something like @tt{add (Successor (Successor Zero), Successor Zero)} evaluates to something like @tt{Successor (Successor (Successor Zero))}. Woop woop.
}
      brk
      @p{
 Bla bla bla
}
      ))

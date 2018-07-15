#lang at-exp racket
(require "structs.rkt")

(provide church-oo-note)

(define church-oo-note
  (nt 'church-oo
      "Church encoding is object-orientation"
      (date 2018 7 15)
      @p{
 The central idea of traditional object-orientation is that everything is a function.
 The thing we can do with a function is apply it to an argument.
 We cannot inspect it, look into how it was constructed.
 Only apply.
}
      @p{
 In a traditional object-oriented language, the argument a function is applied to is a selector-and-arguments-tuple.
}
      @p{
 E.g. some Smalltalk:
}
      @block{
 3 + 2.
 5 negated.
 3 to: 10 by: 2.
}
      @p{That is:}
      @(ul
        @li{@tt{3} applied to the selector @tt{+} and a list of arguments containing @tt{2}.}
        @li{@tt{5} applied to the selector @tt{negated} and the empty list of arguments.}
        @li{@tt{3} applied to the selector @tt{to:by:} and a list of arguments containing @tt{10} and @tt{2}.})

      @p{
 There are details and there is often some cheating and pragmatism going on @em{somewhere}.
 But the idea is that everything is a function and we cannot @q{look inside} a function.
}
      @p{
 A number is a function that behaves and responds appropriately when applied to an argument.
 We do not care how the number is constructed.
 More precicely, we @em{cannot} care how the number is constructed.
}
      @p{Or:}
      (blockquote
       (quot @p{
 If a function walks like a number and it quacks like a number, then it must be a number.
 })
       @cite{―Alonzo Church})

      @p{
 (Contrast with more data-oriented languages like those in the extended ML family.
 Here we typically define numbers by how they are constructed.
 @q{A natural number is zero or the successor of a natural number.}
 And when operating on a number we @em{do} look into how it was cunstructed and do like case analysis (typically by using pattern matching).
 @q{If it is zero, then such and such, if it is the successor of something, then this other thing instead.})
}
      ))



#lang at-exp racket
(require "structs.rkt")

(provide cataphatic-note)

(define cataphatic-note
  (nt 'cataphatic
      "Cataphatic Software Engineering"
      (date 2018 7 16)
      @p{
 A trend is:
 Functional programming advocacy by making functional programming out to
 more or less be @q{regular} programming, @em{minus some stuff}.
}
      @p{
 No side effects, no mutation, ...
}
      @p{
 Like we took @q{programming,} removed for-loops and stuff,
 and then came up with various weird and functional tricks in order
 to make up for what we took away.
}
      @p{
 And like, yea mostly fair enough.
 Some things sometimes cause problems when programming.
 Some of those things don’t come up in functional programming.
 If and when the problems they would cause are more bigger than the problems they would solve,
 it is totally nice of them to don’t.
 Also it’s not like hella weird to start with something more familiar
 and compare functional programming with that.
 And so on.
}
      @p{
 (And I mean anyway it is a fun and mystical idea to e.g.
 describe excactly what a particular programming language is not.)
}
      @p{
 But you know...
}
      @p{
 Anyway and then with types and such,
 it is often about like,
 catching mistakes,
 ruling out classes of errors,
 making illegal states unrepresentable,
 ...
}
      @p{
 (Sometimes there are conversations.
 An Uncle says: @q{Making sure a float does not go where an int should go is not terribly exciting.}
 We explain:
 @q{But we make sure that more interesting things much more sophisticatedly does not go where they should not.}
 It is not clear that excitement is communicated.)
}
      @brk
      @p{
 Anyway a thing I like is that when I’m working with like,
 functions and types and such,
 I am not terribly concerned with like,
 programming language features that are not,
 mistakes and states that can’t be,
 ...
}
      @p{
 If we are @q{making sure a float does not go where an int should go},
 then that does not involve like, saying so. It is never discussed.
 Float is never mentioned. Only int, since that is what @em{should} be.
}

      @p{
 When we define a type, we do not get into like,
 what values are @em{not} inhabitants.
 We only say that a natural number @em{is} zero, or it @em{is} the successor of a natural number.
}

      @p{
 Something like: It is about what is.
 Not what is not.
}

      ))



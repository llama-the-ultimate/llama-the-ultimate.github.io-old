#lang at-exp racket
(provide lamb-nums-note)
(require "structs.rkt")

(define id identity)

(define f @tt{f})
(define x @tt{x})
(define a @tt{a})
(define b @tt{b})
(define foo @tt{foo})
(define bar @tt{bar})

(define lamb-nums-note
  (nt 'lamb-nums
      "Some numbery functions"
      (date 2017 7 6)
      @p{
 Somewhat a test-post, for to have not dead lambda calculus within post.
}
      @p{
 (There’s also kind of a lambda playground @ilnk["/lambdas.html"]{over here}.)
}
      @p{To try, put cursor on line below and do like ctrl+enter couple of times:}
      @lambs[4]{
 (λx.λy.y x) bar foo
}
      @p{
 If it works (if the ctrl+enter-business leads to a line that goes @ttc{foo bar}), we can make like, a few numbers... (ctrl+enter each line).
}
      @p{
 (Oh by the way. Can do ctrl+l to insert a @tt{λ}, and ctrl+d to insert a @tt{≜}.
 Or can use @tt{\} instead of @tt{λ} and @tt{:=} instead of @tt{≜}.)
}
      
      @lambs[8]{
 0 ≜ λf.λx.x
 1 ≜ λf.λx.f x
 2 ≜ λf.λx.f (f x)
 5 ≜ λf.λx.f (f (f (f (f x))))
}

            @p{
 The idea, or at least one way to look at it, is that the number five is the function that does something five times.
 So, if we want to @foo a @bar five times, then we can...
 (Ctrl+r to replace @tt{5} with the lambdas from the definition we did above. Then ctrl+enter a couple of times.)
}
      @lambs[4]{
 5 foo bar
}
           @p{
 Which quite possibly evaluated to @ttc{foo (foo (foo (foo (foo bar))))}. Which is like five @(id foo)s.
 }
      @p{
 Okay. Addition is pretty numbery let’s that. Below is a function that takes arguments @a and @(id b).
 And gives back, uh, a @ttc{λf.λx.}-function.
 This function applies @f @q{@b times} to @x, and applies @f @q{@a times} to the result of that again.
 Hopefully amounts to like, an @a + @b number of @(id f)s applied to @(id x). (ctrl+enter on line below)
}
            @lambs[3]{
 + ≜ λa.λb.λf.λx.a f (b f x)
}
            @p{
 If things seem fine so far, we can try to use it to like, actually additioning.
 Ctrl+r on line below to replace the names of the things we’ve defined with their lambdas.
 Then ctrl+enter a bunch of times to evaluate. (Or ctrl+shift+enter one time.)
}
            @lambs[13]{
 + 5 (+ 5 2)
}
            @p{
 It’s maybe twelve! (Hopefully.)
}

            ))
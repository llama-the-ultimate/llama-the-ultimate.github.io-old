#lang at-exp racket
(provide lamb-nums-note)
(require "structs.rkt"
         "util.rkt")

(deftxt f @tt{f})
(deftxt x @tt{x})
(deftxt a @tt{a})
(deftxt b @tt{b})
(deftxt foo @tt{foo})
(deftxt bar @tt{bar})

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
      @p{To try, put cursor on line below and do like @eval1 couple of times:}
      @lambs[4]{
 (λx.λy.y x) bar foo
}
      @p{
 If it works (if the @(eval1)-business leads to a line that goes @ttc{foo bar}), we can make like, a few numbers... (@eval1 each line).
}
      @p{
 (Oh by the way. Can do @insLam to insert a @tt{λ}, and @insDef to insert a @tt{≜}.
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
 (@substDefs to replace @tt{5} with the lambdas from the definition we did above. Then @eval1 a couple of times.)
}
      @lambs[4]{
 5 foo bar
}
           @p{
 Which quite possibly evaluated to @ttc{foo (foo (foo (foo (foo bar))))}. Which is like five @(foo)s.
 }
      @p{
 Okay. Addition is pretty numbery let’s that. Below is a function that takes arguments @a and @(b).
 And gives back, uh, a @ttc{λf.λx.}-function.
 This function applies @f @q{@b times} to @x, and applies @f @q{@a times} to the result of that again.
 Hopefully amounts to like, an @a + @b number of @(f)s applied to @(x). (@eval1 on line below)
}
            @lambs[3]{
 + ≜ λa.λb.λf.λx.a f (b f x)
}
            @p{
 If things seem fine so far, we can try to use it to like, actually additioning.
 @substDefs on line below to replace the names of the things we’ve defined with their lambdas.
 Then @eval1 a bunch of times to evaluate. (Or @eval* one time.)
}
            @lambs[13]{
 + 5 (+ 5 2)
}
            @p{
 It’s maybe twelve! (Hopefully.)
}

            ))
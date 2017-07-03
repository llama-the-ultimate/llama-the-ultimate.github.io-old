#lang at-exp racket
(provide lamb-nums-note)
(require "structs.rkt")

(define lamb-nums-note
  (nt 'lamb-nums
      "Some numbery functions"
      (date 2017 #f #f)
      @p{
 Somewhat a test-post, for to have not dead lambda calculus within post.
}
      @p{To try, put cursor on line below and do like ctrl+enter couple of times:}
      @lambs[3]{
 (λx.λy.y x) bar foo
}
      @p{
 If it works, we can do a few of the numbers-things (ctrl+enter each line).
}
      @lambs[3]{
 0 ≜ λf.λx.x
 1 ≜ λf.λx.f x
 2 ≜ λf.λx.f (f x)
}

      @p{
 And stuff for adding together.
}
            @lambs[2]{
 plus ≜ λa.λb.λf.λx.a f (b f x)
}
            @p{
 Andalso actually adding.
 Ctrl+r on line below to replace the names of the things we've defined with their lambdas.
 Then ctrl+enter a bunch of times to evaluate. (Or ctrl+shift+enter one time.)
}
            @lambs[10]{
 plus 2 (plus 2 2)
}
            @p{
 Six! (Hopefully.)
}

      ))
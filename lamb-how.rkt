#lang at-exp racket
(provide lamb-how-note)
(require "structs.rkt")

(define lamb-how-note
  (nt 'lamb-how
      "How do the lambdas?"
      (date 2017 7 12)
      
      @p{
 A readonly editor is readonly.
 Its content is evaluated when page loads or so.
 Mostly for adding definitions to toplevel so they can be used later in the post:
}      
      @lambs[6 #:prelude #t]{
 id ≜ λx.x
 0 ≜ λf.λx.x
 ω ≜ λx.x x
}
      @brk
      @p{
 In the regular editors we can do stuff.
}
      @lambs[10]{
 (can do stuff here)
}
      @p{
 Normal text-editor-stuff should work. Lambdastuff in addition:
}
      (ul
       @li{
 @ttc{ctrl+l} inserts a @tt{λ}
 (or can use @tt{\} instead of @tt{λ} if want to)
}
       @li{
 @ttc{ctrl+d} inserts a @tt{≜}
 (or can use @tt{:=} instead of @tt{≜} if want to)
}
       @li{
 @ttc{ctrl+enter} is used to add a definition to toplevel, or remove a definition,
 or do one step of evaluation
}
       @li{
 @ttc{ctrl+shift+enter} is used to do like a bunch of evaluation
 (stops when the term is on normal form, or after like a thousand steps of evaluation)
}
       @li{
 @ttc{ctrl+r} is used to replace the names used in toplevel definitions with terms from the definitions
}
       @li{
 right-clicking within editor and selecting @q{Show definitions}
 prints all the current toplevel defintions in the editor.
 })
      @p{
 @ttc{ctrl+enter}, @ttc{ctrl+shift+enter} and @ttc{ctrl+r} all work on the line the cursor is on.
 Results are printed on new line(s), after.
 (And cursor moves to end of result.)
}
      @brk
      @p{
 So, normally, if we have written some term that maybe uses some of the toplevel defintions,
 we do @ttc{ctrl+r} and then either @ttc{ctrl+enter} a few times, or @ttc{ctrl+shift+enter} once.
 Can try:
}
            
      @lambs[7]{
 (λa.λb.b a) 0 ω 0
}
      @p{
 Lines with @tt{≜} (or @tt{:=} are for definitons).
 @ttc{ctrl+enter} on a line that goes like @ttc{<identifier> ≜ <term>} adds a definition.
}
            
      @lambs[3]{
 S ≜ λn.λf.λx.f (n f x)
}
      @p{
 (Most characters can be used in identifiers.
 Just, not whitespace ones, and not the ones that are used for other stuff:
 @tt{:}, @tt{\}, @tt{≜}, @tt{λ}, @tt{.}, @tt{(}, @tt{)}.)
}

      @p{
 The terms used in definitions can use the names of defintions that already exist.
 Like, we can define @tt{2} like this now, as long as we have defined @tt{0} and @tt{S} first:
 (@ttc{ctrl+enter})
}
      @lambs[3]{
 2 ≜ S (S 0)
}

      @p{
 (We can evaluate it to check that the result looks reasonably twoish.
 Two applications of @tt{f} is very two-like, so the result should look like @ttc{λf.λx.f (f x)}.
 (@ttc{ctrl+r}, then @ttc{ctrl+shift+enter}))
}
      @lambs[8]{
 2
}
      @p{
 If we wanna get rid of a definition we can do @ttc{<identifier> ≜ :(}, or just @ttc{<identifier> ≜}.
 We’ll remove @tt{ω} (it’s scary):
 (@ttc{ctrl+enter})
}
      @lambs[3]{
 ω ≜ :(
}

      @p{
 If we try to evaluate the thing we did earler, we won’t get the same result now,
 since ω will just be treated as some free variable...
 (@ttc{ctrl+r}, then @ttc{ctrl+shift+enter})
}
      @lambs[5]{
 (λa.λb.b a) 0 ω 0}
      @brk
      @p{
 That’s like more or less it.
 In posts like this it’s mostly enough to do @ttc{ctrl+enter} on definitions,
 and @ttc{ctrl+r} and then @ttc{ctrl+shift+enter} on other stuff...
}
      @p{
 The evaluation of the lambda-things is mostly done with
 @lnk["https://github.com/Glorp/purescript-lambs"]{this bit of PureScript-code}.
 The editors are @lnk["https://github.com/Microsoft/monaco-editor"]{Monaco} ones...
}
      ))
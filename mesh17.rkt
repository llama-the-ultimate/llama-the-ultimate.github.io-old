#lang at-exp racket
(provide mesh17-note)
(require "structs.rkt")

(define mesh17-note
  (nt
   'mesh17
   "Code Mesh and infinite llamas"
   (date 2017 11 8)
      
   @p{
 Possibly a bit of a companion post for the Code Mesh talk @lnk["http://www.codemesh.io/codemesh2017/jonas-winje"]{Infinite Lambda Calculus}.
}

   @p{
 Importantliest: The code used, along with some instructions, @lnk["https://github.com/Glorp/lambs/tree/mesh17"]{is on GitHub}.
 The, uh, file we ended up with in the talk @lnk["https://github.com/Glorp/lambs/blob/mesh17/lambs/mesh.txt"]{also is}.
 It is what it is.
}

   @p{
 (Also, there are some related lambdas like, nearby.
 It is possible to take a look over @ilnk["/lists/lambs.html"]{here},
 or just like play with stuff over @ilnk["/lambdas.html"]{there}.)
}
   @brk
   @p{
 Maybe the talk has a main point or something.
 It goes possibly like this:
}
   
   (ul
    @li{We wanna get something like infinite, or at least pretty infinite, loops.}
    @li{Lambda calculus is Turing complete, but it kind of wasn’t supposed to be?}
    @li{Turing complete things can probably do infinite loops,}
    @li{Type systems tend to get rid of like accidental Turing completeness.})
  
   @p{We can come up with a recipe for making a loopy thing:}
  
   (ol @li{
 Look for a tiny expression that wouldn’t typecheck if we had a type system-and-checker.
 (If the type system doesn’t like an expression, then maybe that expression leads to Turing completeness and infinite loops?)
}
       @li{Type checkers sure don’t much like @ttc{λx.x x}.}
       @li{@ttc{(λx.x x) (λx.x x)} goes on and on. For maybe forever?}
       @li{
 Adding e.g. @tt{foo} like so: @ttc{(λx.x x) (λx.foo (x x))} will give us (more than) as many @tt{foo}s as we want.
 Doing a few steps of evaluation will get us @tt{foo (foo ((λx.foo (x x)) (λx.foo (x x))))}.
 If we do more steps we get more @tt{foo}s.}
      
       @li{
 We can do this with like any @tt{f}, instead of just with @tt{foo}, because lambda abstraction:
 @tt{λf.(λx.x x) (λx.f (x x))}.}

       @li{
 One step of evaluation takes @tt{λf.(λx.x x) (λx.f (x x))} to @tt{λf.(λx.f (x x)) (λx.f (x x))}.
 })
   @p{@tt{λf.(λx.f (x x)) (λx.f (x x))} is the Y combinator :)}
   ))
#lang at-exp racket
(provide lamb-what-note)
(require "structs.rkt")

(define x @tt{@str{x}})
(define B @tt{@str{B}})
(define A @tt{@str{A}})
(define id identity)

(define lamb-what-note
  (nt 'lamb-what
      "What do the lambdas?"
      (date 2017 #f #f)
      
      @p{
 A @tt{term} is one of the following:
}
      (ul
       @li{
 @ttc{<identifier>}
 (variable reference)
}
       @li{
 @ttc{λ<identifier>.<term>}
 (function (abstraction))
}
       @li{
 @ttc{<term> <term>}
 (function application)
}
       )

      @p{
 Is like tree. Variable references are leaves.
 Function application branches into two sub-trees, one for function and one for argument.
}
      
      @p{
 Function application is left associative. So @ttc{a b c} and @ttc{(a b) c} works out the same.
}
      @p{
 (So, syntax is mostly like in a ML family language or a Haskell or something.
 Only instead of like, @ttc{fn x => foo} or @ttc{fun x -> foo} or @ttc{\x -> foo}),
 we do @ttc{λx.foo}.)
}
      @brk
      @p{
 Evaluation goes like so: @ttc{(λ@str{x}.@str{B}) @str{A} ⟶ [@str{A}/@str{x}]@str{B}}.
 Meaning, if there’s a function application with
}
      (ul
       @li{
 a function-part that is an function abstraction (lambda thing), with some identifier @x as its parameter
 and some term @B as its body
}
       @li{
 an argument part that is some term @A
 })
      @p{
 then we can substitute the argument @A for every free occurence of the parameter @x in the body @(id B),
 and replace the whole function application with the result of that.
}
      @p{
 Can try.
 With the term @ttc{(λz.z bar) foo}, the paramter @x is @tt{z},
 the body @B is @ttc{z bar}, and the argument @A is @tt{foo}.
 So it should evaluate to the body @ttc{z bar}
 with every free @tt{z} replaced by the argument @tt{foo}: @ttc{foo bar}.
 (@ttc{ctrl+enter} below)
}
      
      @lambs[3]{
 (λz.z bar) foo
}
      @p{
 A variable reference is free if it is not bound by a parameter in a function abstraction (lambda thing).
 With the term @ttc{(λz.z (λz.bar z) bar) foo}, the paramter @x is @tt{z},
 the body @B is @ttc{z (λz.bar z) bar}, and the argument @A is @tt{foo}.
 Here, only the first z in the body @ttc{z (λz.bar z) bar} is free, so only that one is replaced with @tt{foo}.
}
      @lambs[3]{
 (λz.z (λz.bar z) bar) foo
}
      @p{
 (In maybe more programmy jargon, we could maybe say that the inner @tt{z} shadows the outer.)
}
      @p{
 Sometimes we have to change the names of some variables before doing the evaluation thing,
 in order to avoid changing the meaning of things with @q{variable capture}.
 With the term @ttc{(λx.λy.y x) y}, the paramter @x is @tt{x},
 the body @B is @ttc{λy.y x}, and the argument @A is @tt{y}.
 If we just replace the @tt{x} in @ttc{λy.y x} with @tt{y}, we get @ttc{λy.y y}.
 Our argument-@tt{y} becomes like bound by the parameter of the lambda within the body.
 Is no good. We should be able to keep refering to some outer @tt{y}.
 So, we change the name of the parameter of the lambda (and all references to it) before we do the thing.
 (@ttc{ctrl+enter} two times, since the first one will just rename the parameter)
}
      @lambs[3]{
 (λx.λy.y x) y
}
      @brk
      @p{
 That’s mostly it.
 We look through our expression-tree in some order,
 find a function application where the function-part is a function abstraction,
 rename things if necessary,
 and do the substitution thing.
}
      @p{
 The order we look through the expression-tree is normal order.
 We check the outermost expression first, and then the function-parts of applications before the argument-parts.
 (If we can’t find anything to do the substitution-thing on, the term is on @q{normal form}, and we’re like done.)
 (@ttc{ctrl+shift+enter})
}
@lambs[6]{
 (λz.z foo) (λx.λy.x bar y) quux
}
      ))
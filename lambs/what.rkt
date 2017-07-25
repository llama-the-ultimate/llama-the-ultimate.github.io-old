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
      (date 2017 07 24)
      
      @p{
 An @tt{exp}ression is one of the following:
}
      (ul
       @li{
 @ttc{<identifier>}
 (variable reference)
}
       @li{
 @ttc{λ<identifier>.<exp>}
 (function abstraction, but sometimes we’ll just call it a @q{lambda})
}
       @li{
 @ttc{<exp> <exp>}
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
 For example, can take a look at expression @ttc{(λa.a (foo a)) bar} and its sub-expressions:
}
      (ul
       @li{
 @ttc{(λa.a (foo a)) bar} is a function application with a function @ttc{(λa.a (foo a))} and an argument @tt{bar}
}
       @li{
 @ttc{λa.a (foo a)} is a function abstraction with a parameter @tt{x} and a body @ttc{a (foo a)}.
}
       @li{
 @ttc{a (foo a)} is a function application with a function @tt{a} and argument @ttc{foo a}
}
       @li{
 @ttc{foo a} is a function application with a function @tt{foo} and argument @tt{a}
}
       )

      
      @p{
 (So really, syntax is mostly like in a ML family language or a Haskell or something.
 Only instead of like, @ttc{fn x => foo} or @ttc{fun x -> foo} or @ttc{\x -> foo}),
 we do @ttc{λx.foo}.)
}
      @brk
      @p{
 Evaluation goes mostly like so: @ttc{(λ@str{x}.@str{B}) @str{A} ⟶ [@str{A}/@str{x}]@str{B}}.
}
      @p{
 Meaning something like, a @q{reducible expression} (the bit to the left of the arrow) is:
}
      (ul
       @li{
 a function application
}
       @li{
 with a function-part that is a function abstraction, with some identifier @x as its parameter
 and some expression @B as its body
}
       @li{
 and with an argument-part that is some expression @A
 })
      @p{
 And if we have a reducible expression, then we can do @q{beta reduction}: Substitute the argument @A for every free occurence of the parameter @x in the body @(id B),
 and replace the whole function application with the result of that.
}
      @p{
 (The part that goes @ttc{[@str{A}/@str{x}]@str{B}} means that substitution thing: @B but with every free @x replaced with @(id A).
 So @ttc{(λ@str{x}.@str{B}) @str{A} ⟶ [@str{A}/@str{x}]@str{B}} is a bit like a pattern match on the syntax of an expression.
 Like, the expression to the left of the arrow binds the variables @x and @B and @A, and the expression to the right uses them.)
}
      @p{
 Can try.
 With the expression @ttc{(λz.z bar) foo}, the parameter @x is @tt{z},
 the body @B is @ttc{z bar}, and the argument @A is @tt{foo}.
 So for this @q{instance} of @ttc{(λ@str{x}.@str{B}) @str{A} ⟶ [@str{A}/@str{x}]@str{B}}
 we get @ttc{(λz.z bar) foo ⟶ [foo/z]z bar}.
 It should evaluate to the body @ttc{z bar}
 with every free @tt{z} replaced by the argument @tt{foo}: @ttc{foo bar}.
 (@ttc{ctrl+enter} below)
}
      
      @lambs[3]{
 (λz.z bar) foo
}
      @p{
 A variable reference is free if it is not bound by a parameter in a function abstraction.
 With the expression @ttc{(λz.z (λz.bar z) bar) foo}, the parameter @x is @tt{z},
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
 Sometimes we have to change the names of some variables before doing beta reduction,
 in order to avoid having @q{variable capture} change the meaning of our expression.
 With the expression @ttc{(λx.λy.y x) y}, the parameter @x is @tt{x},
 the body @B is @ttc{λy.y x}, and the argument @A is @tt{y}.
 If we just replace the @tt{x} in @ttc{λy.y x} with @tt{y}, we get @ttc{λy.y y}.
 Our argument-@tt{y} becomes like bound (@q{captured}) by the parameter of the lambda within the body.
 Is no good. We should be able to keep refering to some outer @tt{y}.
 So, we change the name of the parameter of the lambda (and all references to it) before we do beta reduction.
 (@ttc{ctrl+enter} two times, since the first one will just rename the parameter)
}
      @lambs[3]{
 (λx.λy.y x) y
}
      @brk
      @p{
 That’s mostly it.
 We:
}
      (ol
       @li{look through our expression-tree in some order}
       @li{maybe find a reducible expression}
       @li{rename things if necessary}
       @li{and do the substitution thing})
      
      @p{
 The order we look through the expression-tree is @q{normal order}.
 We check the outermost expression first, and then the function-parts of applications before the argument-parts.
 If we can’t find any reducible expression, then the expression is on @q{normal form}.
 }

 @p{
 Typically we want to evaluate something down to normal form.
 So we run through those steps over and over until it is.
 (If we’re unlucky that takes actually forever. But that’s cool too.)
}

 @p{
 Can do (@ttc{ctrl+shift+enter}) to evaluate the foillowing until it’s on normal form:
}

 @lambs[6]{
 (λz.z foo) (λx.λy.x bar y) quux
}
      ))
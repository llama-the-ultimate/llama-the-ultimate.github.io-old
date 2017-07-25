#lang at-exp racket
(provide s-parens-note)
(require "structs.rkt")

(deftxt F @tt{@str{F}})
(deftxt A @tt{@str{A}})
(deftxt x @tt{x})
(deftxt y @tt{y})
(deftxt z @tt{z})
(deftxt yz @ttc{y z})
(deftxt foo @tt{foo})
(deftxt S @tt{S})
(deftxt K @tt{K})
(deftxt I @tt{I})
(deftxt B @tt{B})
(deftxt C @tt{C})

(define s-parens-note
  (nt 's-parens
      "S (and parentheses)"
      (date #f #f #f)
      @p{
 In the SKI combinator calculus we have three functions. @S, @K and @(I):
}
      @block{
 I x = x
 K x y = x
 S x y z = x z (y z)
 }
      @p{
 You can translate untyped lambda calculus terms to SKI by following some rules pretty mechanically.
 Anyway the @I and @K functions are reasonably straightforward. The @S is funny.
}
      @p{
 You use the @S when there’s a lambda abstraction that contains one function application:
}
      @block{
 λx.@str{F} @str{A} = S (λx.@str{F}) (λx.@str{A})
}
      @p{
 (Where @F and @A are arbitrary terms (although if @x does not appear free in either @F or @A you can maybe use a simpler rule for translating and get rid of the @x right away).
 You can then go on and translate @ttc{λx.@str{F}} and @ttc{λx.@str{A}} by following the same set of rules, if you wanna.)
}

      @p{
 What with definition of @S earlier, all of this should be fine:
}
            @block{
 S x y z = x z (y z)
 λx.@str{F} @str{A} = S (λx.@str{F}) (λx.@str{A})
 S (λx.@str{F}) (λx.@str{A}) z = (λx.@str{F}) z ((λx.@str{A}) z)
 λx.@str{F} @str{A} = (λx.@str{F}) z ((λx.@str{A}) z)
}
      @p{
 So, we kind of turn the function and the argument of the inner application into function-function and argument-function.
 Now if we apply @ttc{S (λx.@str{F}) (λx.@str{A})} to @foo, @S will pass @foo (its @tt{z}) into @ttc{λx.@str{F}} and @ttc{λx.@str{A}}.
 All free @tt{x}es in @F and @A will be replaced with @(foo). Same as if we applied @ttc{λx.@str{F} @str{A}} to @(foo).
}
      @p{
 The @ttc{x z (y z)} bit used to trip me up. It kind of looks like it passes two arguments, @z and @yz, to @(x).
 And then why does the first argument appear in the second and and ??? I think it became clearer to me when I saw it written with more parentheses: 
}
      @block{
 S x y z = (x z) (y z)
 }
      @p{
 @x is the function-function and @y is the argument-function. They get one @tt{z} each, and the result-function is applied to the result-argument.
}
      @brk
      @p{
 (Also helped to run into @B and @(C). They’re like @S, but @B only passes its @z the the argument-function and @C only passes it to the function-function:
}
      @block{
 S x y z = x z (y z)
 B x y z = x (y z)
 C x y z = x z y
}
      @p{
 Again, with more parentheses:
}
      @block{
 S x y z = (x z) (y z)
 B x y z = x (y z)
 C x y z = (x z) y
}
      @p{
 Like that it’s easier for me to see how they are different, which parts are the same, …)
}
      @brk
      @p{
 There’s something about currying and how it isn’t always clear if it is more useful to think of something as a function that takes two arguments, or a function that returns a function…
}
      @p{
 (Just noticed that on @lnk["https://ncatlab.org/nlab/show/combinatory+logic#the_combinators_s_k_and_i"]{the nLab page} they do put parentheses where I want them. So that’s nice.)
}
 ))

#lang at-exp racket
(provide flat18-note)
(require "structs.rkt")

(define flat18-note
  (nt
   'flat18
   "Beep boop at flatMap"
   (date 2018 5 5)
      
   @p{
 Post that goes with flatMap(Oslo) talk @lnk["http://2018.flatmap.no/talks/host-winje"]{Lambda Calculus Beep Boop}.
}
   @p{
 Slides are @ilnk["/slides/flatmap2018/index.html"]{here}.
}
   @p{
 Various beep boop evaluators. Maybe they work in some of the browsers. The later ones are more fun...
}

   (ul
    @li{@ilnk["/slides/flatmap2018/beep-boop/0-beops.html"]{Beop}. Only shows the beep-boops.}
    @li{@ilnk["/slides/flatmap2018/beep-boop/1-beops-bru.html"]{Bru}. Also shows De Bruijn index expressions.}
    @li{@ilnk["/slides/flatmap2018/beep-boop/2-beops-bru-lamb.html"]{Lamb}. Also shows more regular lambda expressions.}
    @li{@ilnk["/slides/flatmap2018/beep-boop/3-beops-bru-lamb-eval.html"]{Eval}. Also shows @q{next expression} when an expression can be reduced.}
    @li{@ilnk["/slides/flatmap2018/beep-boop/4-sounds.html"]{Sounds}. Also makes sounds when pressing buttons.}
    @li{
 @ilnk["/slides/flatmap2018/beep-boop/5-playback.html"]{Playback}.
 Also makes sounds when the expression is finished, and automatically does a step of evaluation after playing sounds.
}
    @li{@ilnk["/slides/flatmap2018/beep-boop/6-rectangles.html"]{Rectangles}. Also draws coloured rectangles.}
    @li{
 @ilnk["/slides/flatmap2018/beep-boop/7-only-rectangles.html"]{Only rectangles}.
 Like the @q{rectangles} one, but shows only the rectangles when the expression is finished/being evaluated.
}
    @li{@ilnk["/slides/flatmap2018/beep-boop/8-fish.html"]{Fish}. Like the @q{rectangles} one but with fish.}
    @li{@ilnk["/slides/flatmap2018/beep-boop/9-only-fish.html"]{Only fish}. Like the @q{only rectangles} one but with fish.})

   @p{Some controls:}
   (ul
    @li{A does beep.}
    @li{S does boop.}
    @li{D does bap.}
    @li{F does pling.}
    @li{Backspace takes removes the latest/rightmost word (beep/boop/bap/pling) from current expression.}
    @li{
 Space does a step of evaluation, if the expression is finished and can be reduced.
 (Unnecessary with the @q{playback} evaluator and later ones, as they kind of automatically evluate.)
 })

   @p{And like:}
   (ul
    @li{Beep introduces a lambda. After a beep you have to write the body of the lambda.}
    @li{Some boops and then a bap is a variable reference. Boop bap is 1, boop boop bap is 2, and so on. (The numbers work like De Bruijn indices.)}
    @li{Pling does function application. After a pling you have to write the function and then after that the argument.})

   @p{
 So the identiy function is beep boop bap (A S D).
 The Church encoded number one is beep beep pling boop boop bap boop bap (A A F S S D S D).
 Stuff like that.
}

   @p{
 A fancy exprssion, like a @q{2 + 3} one, can be written like so:
}

   @p{F F A A A A F F S S S S D S S D F F S S S D S S D S D A A F S S D F S S D S D A A F S S D F S S D F S S D S D}

   @p{Okay.}

   @p{
 Oh and like it is possible to, uh, cheat?
 Like instead of pressing the buttons, can probably open the JavaScript console and go like:
}

   @block{
 [pling, pling, beep, beep, beep, beep, pling, pling, boop, boop, boop, boop, bap, boop, boop, bap, pling, pling, boop, boop, boop, bap, boop, boop, bap, boop, bap, beep, beep, pling, boop, boop, bap, pling, boop, boop, bap, boop, bap, beep, beep, pling, boop, boop, bap, pling, boop, boop, bap, pling, boop, boop, bap, boop, bap].forEach(doBeop);
}
   @p{(Maybe make sure the soundstuff is initalized first. Like press space and hear a sound before doing JavaScript stuff.)}
   ))
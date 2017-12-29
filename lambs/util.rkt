#lang at-exp racket
(require "structs.rkt")
(provide eval1
         eval*
         subst-defs
         ins-lam
         lam
         alt-lam
         ins-def
         def
         alt-def
         numberdef)

(deftxt eval1 @ttc{ctrl+enter})
(deftxt eval* @ttc{ctrl+shift+enter})
(deftxt subst-defs @ttc{ctrl+r})

(deftxt ins-lam @ttc{ctrl+l})
(deftxt lam @tt{λ})
(deftxt alt-lam @tt{\})


(deftxt ins-def @ttc{ctrl+d})
(deftxt def @tt{≜})
(deftxt alt-def @tt{:=})

(deftxt numberdef @txt{
 The number @em{n} is a function that,
 if given two arguments,
 applies the first argument @em{n} times to the second.})

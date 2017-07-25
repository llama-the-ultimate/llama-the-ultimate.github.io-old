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
         alt-def)

(deftxt eval1 @ttc{ctrl+enter})
(deftxt eval* @ttc{ctrl+shift+enter})
(deftxt subst-defs @ttc{ctrl+r})

(deftxt ins-lam @ttc{ctrl+l})
(deftxt lam @tt{λ})
(deftxt alt-lam @tt{\})


(deftxt ins-def @ttc{ctrl+d})
(deftxt def @tt{≜})
(deftxt alt-def @tt{:=})

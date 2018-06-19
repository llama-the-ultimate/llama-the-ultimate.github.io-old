#lang at-exp racket
(provide technical-debt-note)
(require "structs.rkt")

(define technical-debt-note
  (nt
   'technical-debt
   "The 4 types of technical debt"
   (date 2018 6 19)
      
   @p{
 I think this title is pretty thought leader because it sounds like fairly assertive and also has a number in it.
}
   (ol @li{Technical debt}
       @li{Not technical debt}
       @li{Technical not debt}
       @li{Not technical not debt})
   ))
#lang at-exp racket
(require "structs.rkt")
(provide eval1
         eval*
         substDefs
         insLam
         insDef)

(define eval1 (txt @ttc{ctrl+enter}))
(define eval* (txt @ttc{ctrl+shift+enter}))
(define substDefs (txt @ttc{ctrl+r}))

(define insLam (txt @ttc{ctrl+l}))
(define insDef (txt @ttc{ctrl+d}))

#lang at-exp racket
(require "html.rkt")
(provide lambda-playground)

(define (halp from name . rest)
  (editor-html-xexpr from name (apply ~a rest)))

(define (lambda-playground from)
  @halp[from "Lambdas"]{
                        
 ctrl+l inserts λ
 ctrl+d inserts ≜
 ctrl+enter does one step of evaluation or define/undefine
 ctrl+r rewrites stuff and replaces names defined elsewhere with their definitions
 ctrl+shift+enter does lots of evaluation
 right-click and Show definitions to list the available definitions
 
 e.g.
 put cursor on line below and ctrl+enter
 0 ≜ λf.λx.x
 
 put cursor on line below and ctrl+enter
 S ≜ λn.λf.λx.f (n f x)
 
 put cursor on line below and ctrl+enter
 2 ≜ S (S 0)
 
 put cursor on line below and ctrl+enter
 + ≜ λa.λb.a S b
 
 put cursor on line below and ctrl+enter
 6 ≜ + 2 (+ 2 2)
 
 put cursor on line below and ctrl+r, then ctrl+shift+enter
 + 6 6
 
 })
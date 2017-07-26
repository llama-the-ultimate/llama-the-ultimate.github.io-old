#lang racket
(provide draw-expr)

(require "draw.rkt"
         "structs.rkt"
         "tree-structs.rkt"
         "unparse.rkt"
         2htdp/image)

(define (expr->tree x)
  (match x
    [(ref s) (tr x)]
    [(lam p b) (tr x (expr->tree b))]
    [(app f a) (tr x (expr->tree f) (expr->tree a))]))

(define (expr->img x)
  (define expr-str (unparse x))
  (define top-str
    (match x
      [(ref s) "(reference)"]
      [(lam p b) "(abstraction)"]
      [(app f a) "(application)"]))
  (above (draw-text top-str)
         (rectangle 0 3 'solid (color 0 0 0 0))
         (draw-text expr-str)))

(define draw-expr
  (compose draw
           (tree-map expr->img)
           expr->tree))

(module+ main
  (require "parse.rkt")
  (draw-expr (parse "(λn.λf.λx.f (n f x)) (λf.λx.f (f x))")))
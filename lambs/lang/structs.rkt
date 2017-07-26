#lang racket
(provide expr?
         (struct-out ref)
         (struct-out lam)
         (struct-out app))

(struct lam (p x) #:transparent)
(struct app (f a) #:transparent)
(struct ref (s) #:transparent)

(define (expr? x)
  (match x
    [(lam p x) (and (symbol? p) (expr? x))]
    [(app f a) (and (expr? f) (expr? a))]
    [(ref s) (symbol? s)]
    [_ #f]))


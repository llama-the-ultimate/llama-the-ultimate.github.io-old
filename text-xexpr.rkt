#lang racket
(provide text->xexpr
         paragrpah->xexpr)

(require "structs.rkt")

(struct state (quote-level) #:transparent)

(define (paragrpah->xexpr p)
  (match p
    [(paragraph (list ts ...)) `(p ((class "par")) ,@(apply append (map text->xexpr ts)))]))

(define (text->xexpr ts)
  ((text->xexpr-halp (state 0)) ts))

(define ((text->xexpr-halp st) t)
  (define (tag-all st tag ts)
    `((,@tag ,@(apply append (map (text->xexpr-halp st) ts)))))
  
  (match t
    [(? string?) (list t)]
    [(emphasis ts) (tag-all st '(em ()) ts)]
    [(strong ts) (tag-all st '(strong ()) ts)]
    [(quoted ts) (quot st ts)]))

(define (quot st ts)
    (define q-lvl (state-quote-level st))
    (define  q-start (if (even? q-lvl) "“" "‘"))
    (define  q-end (if (even? q-lvl) "”" "’"))

    `(,q-start
      ,@(apply append (map (text->xexpr-halp (state (+ q-lvl 1))) ts))
      ,q-end))


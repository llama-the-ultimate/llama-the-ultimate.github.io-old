#lang racket
(provide text->xexpr
         text-piece->xexpr)

(require "structs.rkt")

(struct state (quote-level) #:transparent)

(define (text-piece->xexpr p)
  (match p
    [(paragraph (list ts ...)) `(p () ,@(apply append (map text->xexpr ts)))]
    [(ordered-list (list tss ...)) `(ol () ,@(map ts->li tss))]
    [(unordered-list (list tss ...)) `(ul () ,@(map ts->li tss))]))

(define (ts->li ts)
  `(li () ,@(apply append (map text->xexpr ts))))

(define (text->xexpr t)
  ((text->xexpr-halp (state 0)) t))

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


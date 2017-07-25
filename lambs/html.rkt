#lang racket
(provide (all-from-out "../html.rkt")
         lambs-text-piece->html
         lambs-pieces->html)

(require "structs.rkt"
         "../html.rkt")

(define (lambs-pieces->html from pieces)
  (append* (map (lambs-text-piece->html from) pieces)))

(define ((lambs-text-piece->html from) p)
  (match p
    [(lambs-editor h p s)
     `((div ((class "editor")
             (name "lambs")
             (style ,(lambs-style h))
             ,@(if p '((prelude "true")) '()))
            ,s))]
    [_ ((text-piece->html from) p)]))

(define (lambs-style h)
  (format "height:~arem" h))
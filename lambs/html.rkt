#lang racket
(provide (all-from-out "../html.rkt")
         lambs-text-piece->html
         lambs-pieces->html)

(require "structs.rkt"
         "../html.rkt")

(define (lambs-pieces->html note-id from pieces)
  (append* (map (lambs-text-piece->html note-id from) pieces)))

(define ((lambs-text-piece->html note-id from) p)
  (match p
    [(lambs-editor h p s)
     `((div ((class "editor")
             (name "lambs")
             (style ,(lambs-style h))
             ,@(if p '((prelude "true")) '()))
            ,s))]
    [_ ((text-piece->html note-id from) p)]))

(define (lambs-style h)
  (format "height:~arem" h))
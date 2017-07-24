#lang racket
(provide (all-from-out "../html.rkt")
         lambs-text-piece->html)

(require "structs.rkt"
         "../html.rkt")

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
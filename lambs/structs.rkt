#lang racket
(provide (all-from-out "../structs.rkt")
         (struct-out lambs-editor)
         lambs)

(require "../structs.rkt")

(struct lambs-editor (height prelude text) #:transparent)
(define (lambs h #:prelude [prelude #f] . rest)
  (lambs-editor h prelude (apply ~a rest)))
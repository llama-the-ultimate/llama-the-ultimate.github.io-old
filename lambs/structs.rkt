#lang racket
(provide (all-from-out "../structs.rkt")
         (struct-out lambs-editor)
         lambs
         (struct-out lambs-content)
         lambs-nt)

(require "../structs.rkt")

(struct lambs-editor (height prelude text) #:transparent)
(define (lambs h #:prelude [prelude #f] . rest)
  (lambs-editor h prelude (apply ~a rest)))

(struct lambs-content (pieces) #:transparent)
(define (lambs-nt id name date . pieces)
  (note id
        name
        date
        (lambs-content pieces)))

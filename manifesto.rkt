#lang at-exp racket
(require "structs.rkt")

(provide manifesto-note)

(define manifesto-note
  (nt 'manifesto
      "Manifesto for software development"
      (date 2018 10 6)
      @p{Small over large.}
      @p{I value the item on the left more.}
      ))



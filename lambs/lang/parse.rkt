#lang racket
(provide (rename-out [parse-expr-string parse]))
         

(require "parse/parse-expr.rkt"
         "parse/str.rkt")

(define parse-expr-string (compose parse-expr string->str))

(module+ test
  (require rackunit
           "structs.rkt")
  
  (check-equal? (parse-expr-string "asd (qwe (λx.x x)) erw")
                (app (app (ref 'asd) (app (ref 'qwe) (lam 'x (app (ref 'x) (ref 'x))))) (ref 'erw))))


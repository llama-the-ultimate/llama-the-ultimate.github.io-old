#lang racket
(provide unparse)
(require "structs.rkt")

(define (paren s)
  (~a "(" s ")"))

(define (unparse x)
  (match x
    [(lam p x) (format "λ~a.~a" p (unparse x))]
    [(app (lam p b) a) (format "~a ~a" (paren (unparse (lam p b))) (argstring a))]
    [(app f a) (format "~a ~a" (unparse f) (argstring a))]
    [(ref s) (symbol->string s)]))

(define (argstring x)
  (match x
    [(ref s) (~a s)]
    [x (paren (unparse x))]))


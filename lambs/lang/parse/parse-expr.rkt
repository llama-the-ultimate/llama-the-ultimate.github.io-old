#lang racket
(provide parse-expr)

(require "../structs.rkt"
         "../opt.rkt"
         "str.rkt"
         "util.rkt")

(define (expr-list->expr expr-l)
  (left-assoc app expr-l))
  
(define (parse-expr x)
  (define res
    (opt>
     (read-expr-list x)
     [expr-l
      (expr-list->expr expr-l)]))
  (and (expr? res) res))

(define (read-expr-list y)
  (define ((add-expr x) rest-str)
    (opt> (read-expr-list rest-str)
          [rest (cons x rest)]))
  
  (define (halp y)
    (define x (skip-whites y))
    (cond [(str-empty? x) '()]
          
          [(equal? (str-current x) #\()
           (opt> ((split #\)) (next x))
                 [(cons inside rest)
                  (opts>
                   ((parse-expr inside) (halp rest))
                   [(a d) (cons a d)])])]
          
          [(equal? (str-current x) #\λ)
           (opt>
            (read-lambda x)
            [l (list l)])]
             
          [else
           (match (read-word x)
             [#f #f]
             [(cons w rest)
              (opt>
               (halp rest)
               [rest-list (cons (ref (string->symbol w)) rest-list)])])]))
  (match (halp y)
    ['() #f]
    [x x]))

(define (read-lambda x)
  (opt>
   ((expect-string "λ") x)
   [lam-rest
    (opt> (read-word lam-rest)
    [(cons param param-rest)
     (opt>
      ((expect-string ".") param-rest)
      [body
       (opt>
        (parse-expr body)
        [l (lam (string->symbol param) l)])])])]))

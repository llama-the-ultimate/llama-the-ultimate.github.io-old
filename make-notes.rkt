#lang racket

(require "lambs/structs.rkt"
         "lambs/html.rkt")

(define (note->xexpr from n #:pre [pre '()] #:post [post '()])
  (match n
    [(note id name d (content pieces))
     (->html-xexpr (note->url n)
                   name
                   `((h1 () ,name)
                     ,@pre
                     ,@(pieces->html from pieces)
                     ,@post))]
    [(note id name d (lambs-content pieces))
     (->lambs-html-xexpr (note->url n)
                         name
                         `((h1 () ,name)
                           ,@pre
                           ,@(lambs-pieces->html from pieces)
                           ,@post))]))

(define (notes->links from notes)
  `((ul ()
        ,@(map (λ (n)
                 `(li () ,@((thing->link/date from) n)))
               notes))))

(define (write-list-file l)
  (match l
    [(note-list nt nts)
     (match nt
       [(note id name d content)
        (define url (note-list->url l))
        (define post (notes->links url nts))
        (write-html-file (relative-url "/" url) (note->xexpr url nt #:post post))])]))

(define (write-note-file n)
  (match n
    [(note id name date pars)
     (define url (note->url n))
     (write-html-file (relative-url "/" url) (note->xexpr url n))]))

(require "notes.rkt")
(write-note-file test-note)
(require "data-functions-note.rkt")
(write-note-file data-functions-note)
(require "s-parens-note.rkt")
(write-note-file s-parens-note)
(require "tuples-note.rkt")
(write-note-file tuples-note)

(require "LISP-forty-two.rkt")

(define notes (list* LISP-forty-two-note small-notes))

(for ([n notes]) (write-note-file n))

(require "lambs/lambs.rkt")
(write-list-file lambs-list)

(define lamb-notes (note-list-notes lambs-list))
(for ([n lamb-notes]) (write-note-file n))

(require "lambs/playgrounds.rkt")
(write-html-file "lambdas.html"
                 (lambda-playground "/"))

(write-html-file "index.html"
                 (->html-xexpr "/"
                               "Some stuff"
                               `((h1 () "Um")
                                 (p ()
                                    "Some lambdas over "
                                    (a ([href "lambdas.html"]) "there")
                                    ".")
                                 (p () "And like a stuff:")
                                 ,@(notes->links "/"
                                                 (filter note-date
                                                         (sort (append lamb-notes notes)
                                                               (compose not note-before?)))))))


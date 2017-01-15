#lang racket

(require "structs.rkt"
         "notes.rkt"
         "html.rkt"
         "text-xexpr.rkt"
         (only-in xml xexpr->string))

(define (note->url-string n)
  (match n
     [(note id name pars)
      (~a "/notes/" id ".html")]))

(define (note->xexpr n)
  (match n
    [(note id name pieces)
     (->html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(map text-piece->xexpr pieces)))]))

(define ((note->link from) n)
  (match n
    [(note id name pars)
     `(p ()
         (a ([href ,(relative-url from (note->url-string n))]) ,name))]))

(define (write-note-file n)
  (match n
    [(note id name pars)
     (write-html-file (relative-url "/" (note->url-string n)) (note->xexpr n))]))
     

(for ([n notes]) (write-note-file n))

(write-note-file test-note)
(require "data-functions-note.rkt")
(write-note-file data-functions-note)

(require "s-parens-note.rkt")
(write-note-file s-parens-note)

(define index
  (write-html-file "index.html"
                   (->html-xexpr "/"
                                 "Some stuff"
                                 `((h1 () "Um")
                                   (p ()
                                      "Some lambdas over "
                                      (a ([href "lambders.html"]) "there")
                                      ".")
                                   (p () "And like a stuff:")
                                   ,@(map (note->link "/") notes)))))


#lang racket

(require "structs.rkt"
         "notes.rkt"
         "html.rkt"
         "text-xexpr.rkt"
         (only-in xml xexpr->string))

(define (note->url-string n)
  (match n
     [(note id name desc pars)
      (~a "/notes/" id ".html")]))

(define (note->xexpr n)
  (match n
    [(note id name desc pieces)
     (->html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(map text-piece->xexpr pieces)))]))

(define ((note->link from) n)
  (match n
    [(note id name desc pars)
     `(p ()
         (a ([href ,(relative-url from (note->url-string n))]) ,name)
         ,(~a " (" desc ")"))]))

(define (write-note-file n)
  (match n
    [(note id name desc pars)
     (write-html-file (relative-url "/" (note->url-string n)) (note->xexpr n))]))
     

(for ([n notes]) (write-note-file n))

(write-note-file test-note)
(require "data-note.rkt")
(write-note-file data-note)

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


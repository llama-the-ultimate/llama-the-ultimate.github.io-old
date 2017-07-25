#lang racket

(require "lambs/structs.rkt"
         "lambs/html.rkt")

(define (note->url-string n)
  (match n
     [(note id name _ _)
      (~a "/notes/" id ".html")]))

(define (note->xexpr from n)
  (match n
    [(note id name d (content pieces))
     (->html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(append* (map (text-piece->html from) pieces))))]
    [(note id name d (lambs-content pieces))
     (->lambs-html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(append* (map (lambs-text-piece->html from) pieces))))]))

(define ((note->link from) n)
  (match n
    [(note id name d _)
     `(p ()
         (a ([href ,(relative-url from (note->url-string n))]) ,name)
         ,(format " (~a)" (date->string d)))]))

(define (write-note-file n)
  (match n
    [(note id name date pars)
     (define url (note->url-string n))
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

(require "lambs/nums.rkt"
         "lambs/how.rkt"
         "lambs/what.rkt")
(define lamb-notes (list lamb-nums-note lamb-how-note lamb-what-note))
(for ([n lamb-notes]) (write-note-file n))

(define notes (list* LISP-forty-two-note small-notes))

(for ([n notes]) (write-note-file n))


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
                                 ,@(map (note->link "/")
                                        (sort (append lamb-notes notes)
                                              (compose not note-before?))))))


#lang racket

(require "structs.rkt"
         "html.rkt"
         "text-xexpr.rkt")

(define (note->url-string n)
  (match n
     [(note id name _ _)
      (~a "/notes/" id ".html")]))

(define (note->xexpr from n)
  (match n
    [(note id name d pieces)
     (->html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(append* (map (text-piece->xexpr from) pieces))))]))

(define ((lambs-text-piece->xexpr from) p)
  (match p
    [(lambs-editor h s) `((div ((class "editor") (name "lambs") (style ,(lambs-style h))) ,s))]
    [_ ((text-piece->xexpr from) p)]))

(define (lambs-style h)
  (format "height:~arem" h))
     
(define (lambs-note->xexpr from n)
  (match n
    [(note id name d pieces)
     (->lambs-html-xexpr (note->url-string n)
                   name
                   `((h1 () ,name)
                     ,@(append* (map (lambs-text-piece->xexpr from) pieces))))]))

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

(define (write-lambs-note-file n)
  (match n
    [(note id name date pars)
     (define url (note->url-string n))
     (write-html-file (relative-url "/" url) (lambs-note->xexpr url n))]))

(require "notes.rkt")
(write-note-file test-note)
(require "data-functions-note.rkt")
(write-note-file data-functions-note)
(require "s-parens-note.rkt")
(write-note-file s-parens-note)
(require "tuples-note.rkt")
(write-note-file tuples-note)

(require "LISP-forty-two.rkt")

(require "lamb-nums.rkt")
(write-lambs-note-file lamb-nums-note)

(define notes (list* LISP-forty-two-note small-notes))

(for ([n notes]) (write-note-file n))


(require "lambda-playgrounds.rkt")
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
                                        (sort (cons lamb-nums-note notes)
                                              (compose not note-before?))))))


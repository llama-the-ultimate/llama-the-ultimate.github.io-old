#lang racket

(require "lambs/structs.rkt"
         "lambs/html.rkt"
         "svg.rkt")

(define (note->xexpr from n #:pre [pre '()] #:post [post '()])
  (define (dateindex d)
    `(div ((class "belowtitle"))
          "("
          ,@(if d `(,(date->string d) ". ") '())
          (a ((class "homelink") (href ,(relative-url from "/index.html"))) "Index.")
          ")"))
    
  (match n
    [(note id name d (content pieces))
     (->html-xexpr (note->url n)
                   name
                   `((h1 () ,name)
                     ,(dateindex d)
                     ,@pre
                     ,@(pieces->html id from pieces)
                     ,@post))]
    [(note id name d (lambs-content pieces))
     (->lambs-html-xexpr (note->url n)
                         name
                         `((h1 () ,name)
                           ,(dateindex d)
                           ,@pre
                           ,@(lambs-pieces->html id from pieces)
                           ,@post))]))


(define (notes->links from notes)
  `((ul ()
        ,@(map (λ (n)
                 `(li () ,@((thing->link/date from) n)))
               notes))))

(define (dbg x) (display x) (newline) x)

(define (note-list->pre-text from note-list previous next)
  `((p ((class "listinfo"))
       "This post is part of a list: "
       ,@((thing->link from) note-list)
       ,@(if next `((br ()) "Next thing: " ,@((thing->link from) next)) '())
       ,@(if previous `((br ()) "Previous thing: " ,@((thing->link from) previous)) '()))))

(define (maybe-save-img x dir [alt ""])
  (define reldir (relative-url "/" dir))
  (match x
    [(img (svg name i) alt)
     (make-directory* reldir)
     (save-svg-file i (~a name) (format "~a/~a.svg" reldir name))]
    [_ (void)]))

(define (save-images x)
  (define (content->pieces c)
    (match c
      [(content ps) ps]
      [(lambs-content ps) ps]))
  (match x
    [(note id _ _ c)
     (for ([p (content->pieces c)]) (maybe-save-img p (format "/notes/~a" id)))]
    [(note-list (note id _ _ c) nts)
     (for ([p (content->pieces c)]) (maybe-save-img p (format "/lists/~a" id)))
     (for ([nt nts]) (save-images nt))]))

(define (write-list-files l)
  (save-images l)
  (define list-url (note-list->url l))

  (define (write-note nt previous next)
    (define note-url (note->url nt))
    (define pre (note-list->pre-text note-url l previous next))
    (write-html-file (relative-url "/" note-url) (note->xexpr note-url nt #:pre pre)))
  
  (define (write-notes nts)
    (define (write-first nts)
      (match nts
        ['() (void)]
        [(list nt) (write-note nt #f #f)]
        [(list nt next-nt _ ...)
         (write-note nt #f next-nt)
         (write-rest nts)]))
    (define (write-rest nts)
      (match nts
        [(list prev-nt nt) (write-note nt prev-nt #f)]
        [(list prev-nt nt next-nt xs ...)
         (write-note nt prev-nt next-nt)
         (write-rest (list* nt next-nt xs))]))
    (write-first nts))
  
  (match l
    [(note-list nt nts)
     (define ready (filter note-date nts))
     (define not-ready (filter (compose not note-date) nts))

     (write-notes ready)
     (for ([n not-ready]) (write-note n #f #f))
     
     (match nt
       [(note id name d content)
        (define post (notes->links list-url ready))
        (write-html-file (relative-url "/" list-url) (note->xexpr list-url nt #:post post))])]))

(define (write-note-file n)
  (save-images n)
  (match n
    [(note id name date pars)
     (define url (note->url n))
     (write-html-file (relative-url "/" url) (note->xexpr url n))]))

(require "notes.rkt"
         "data-functions-note.rkt"
         "s-parens-note.rkt"
         "tuples-note.rkt"
         "LISP-forty-two.rkt"
         "foldr-note.rkt"
         "mesh17.rkt"
         "time.rkt"
         "flat18.rkt"
         "types-of-functions.rkt"
         "some-books.rkt"
         "technical-debt.rkt"
         "church-oo.rkt"
         "cataphatic.rkt"
         "manifesto.rkt"
         "js-sums.rkt")

(define notes (list* test-note
                     data-functions-note
                     s-parens-note
                     tuples-note
                     LISP-forty-two-note
                     foldr-note
                     mesh17-note
                     time-note
                     flat18-note
                     types-of-functions-note
                     some-books-note
                     technical-debt-note
                     church-oo-note
                     cataphatic-note
                     manifesto-note
                     js-sums-note
                     small-notes))

(for ([n notes]) (write-note-file n))

(require "lambs/lambs.rkt")
(write-list-files lambs-list)

(define lamb-notes (note-list-notes lambs-list))

(require "lambs/playgrounds.rkt")
(write-html-file "lambdas.html"
                 (lambda-playground "/"))

(write-html-file "index.html"
                 (->html-xexpr "/"
                               "Llama llama"
                               `((h1 () "Llama llama")
                                 (p ()
                                    "Blah blah. I’m a Jonas. My Twitter is "
                                    (a ([href "https://twitter.com/JonasWinje"]) "here")
                                    " and my GitHub is "
                                    (a ([href "https://github.com/Glorp"]) "there")
                                    ".")
                                 (p ()
                                    "For lambda calculus things, "
                                    (a ([href "lists/lambs.html"]) "this")
                                    " is maybe good starting point.")
                                 (p () "Also, stuff:")
                                 ,@(notes->links "/"
                                                 (filter note-date
                                                         (sort (append lamb-notes notes)
                                                               (compose not note-before?)))))))


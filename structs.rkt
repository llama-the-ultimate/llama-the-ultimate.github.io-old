#lang racket
(provide (struct-out note)
         nt
         note-before?
         (struct-out date)
         date->string
         current-date
         date<
         (struct-out paragraph)
         p
         (struct-out quotation)
         quot
         (struct-out citation)
         cite
         (struct-out blockquote)
         (struct-out emphasis)
         em
         (struct-out strong)
         str
         (struct-out quoted)
         q
         (struct-out unordered-list)
         ul
         (struct-out ordered-list)
         ol
         li
         (struct-out link)
         lnk
         ilnk
         (struct-out ref/url)
         (struct-out ref/internal)
         (struct-out codeblock)
         block
         (struct-out code)
         ttc
         (struct-out code-word)
         tt
         (struct-out break)
         brk
         (struct-out txts)
         txt
         deftxt)

(require (only-in racket/date [current-date racket-current-date]))

(struct note (id name date pieces) #:transparent)
(define (nt id name date . pieces)
  (note id
        name
        date
        pieces))

(define (note-before? a b)
  (match* (a b)
    [((note _ _ ad _) (note _ _ bd _))
     (date< ad bd)]))

(struct emphasis (ts) #:transparent)
(define (em . ts)
  (emphasis ts))

(struct paragraph (ts) #:transparent)
(define (p . ts)
  (paragraph ts))

(struct quotation (ps) #:transparent)
(define (quot . ps)
  (quotation ps))
(struct citation (ts) #:transparent)
(define (cite . ts)
  (citation ts))
(struct blockquote (q c) #:transparent)

(struct strong (ts) #:transparent)
(define (str . ts)
  (strong ts))

(struct quoted (ts) #:transparent)
(define (q . ts)
  (quoted ts))

(struct ordered-list (tss) #:transparent)
(define (ol . tss)
  (ordered-list tss))

(struct unordered-list (tss) #:transparent)
(define (ul . tss)
  (unordered-list tss))

(define li list)

(struct ref/url (url) #:transparent)
(struct ref/internal (url) #:transparent)

(struct link (ref ts) #:transparent)

(define (lnk url . ts)
  (link (ref/url url) ts))

(define (ilnk url . ts)
  (link (ref/internal url) ts))

(struct codeblock (ts) #:transparent)
(define (block . ts)
  (codeblock ts))

(struct code (ts) #:transparent)
(define (ttc . ts)
  (code ts))

(struct code-word (ts) #:transparent)
(define (tt . ts)
  (code-word ts))

(struct break () #:transparent)
(define brk (break))


         
(struct date (year month day) #:prefab)

(define (current-date)
  (match (racket-current-date)
    [(date* _ _ _ d m y _ _ _ _ _ _) (date y m d)]))

(define (my< a b)
  (match* (a b)
    [(#f #f) #f]
    [(_ #f) #t]
    [(#f _) #f]
    [(a b) (< a b)]))

(define (date< a b)
  (match* (a b)
    [(#f #f) #f]
    [(_ #f) #t]
    [(#f _) #f]
    [((date a-y a-m a-d) (date b-y b-m b-d))
     (cond [(my< a-y b-y) #t]
           [(my< b-y a-y) #f]
           [(my< a-m b-m) #t]
           [(my< b-m a-m) #f]
           [else (< a-d b-d)])]))

(define (date->string d)
  (define (halp x)
    (~a (or x "??") #:width 2 #:align 'right #:pad-string "0"))
  (define (halpy x)
    (~a (or x "????") #:width 4 #:align 'right #:pad-string "0"))
  (match (or d (date #f #f #f))
    [(date y m d) (format "~a-~a-~a"
                          (halpy y)
                          (halp m)
                          (halp d))]))
(struct txts (ts)
  #:transparent
  #:property prop:procedure (λ (x) x))
  
(define (txt . ts)
  (txts ts))

(define-syntax-rule (deftxt name ts ...)
  (define name (txt ts ...)))
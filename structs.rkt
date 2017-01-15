#lang racket
(provide (struct-out note)
         nt
         (struct-out paragraph)
         p
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
         (struct-out link/url)
         lnk
         (struct-out codeblock)
         block
         (struct-out code)
         ttc
         (struct-out code-word)
         tt
         (struct-out break)
         brk)

(struct note (id name pieces) #:transparent)
(define (nt id name . pieces)
  (note id
        name
        pieces))


(struct emphasis (ts) #:transparent)
(define (em . ts)
  (emphasis ts))

(struct paragraph (ts) #:transparent)
(define (p . ts)
  (paragraph ts))

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

(struct link/url (url ts) #:transparent)
(define (lnk url . ts)
  (link/url url ts))


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
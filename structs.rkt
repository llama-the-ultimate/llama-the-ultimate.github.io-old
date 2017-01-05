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
         q)

(struct note (id name desc pars) #:transparent)
(define (nt id name desc . pars)
  (note id
        name
        desc
        pars))



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
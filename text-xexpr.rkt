#lang racket
(provide text-piece->xexpr)

(require "structs.rkt"
         (only-in "html.rkt" relative-url))

(struct state (quote-level) #:transparent)

(define ((text-piece->xexpr from) p)
  
  (define (text-piece->xexpr p)
    (match p
      [(paragraph (list ts ...)) `((p () ,@(append* (map text->xexpr ts))))]
      
      [(break) '((hr))]
      
      [(blockquote (quotation ps) (citation ts))
       `((blockquote
          ()
          ,@(append* (map text-piece->xexpr ps))
        (footer () (cite () ,@(append* (map text->xexpr ts))))))]
      
      [(codeblock (list ts ...)) `((pre () ,@(append* (map text->xexpr ts))))]
      
      [(ordered-list (list tss ...)) `((ol () ,@(map ts->li tss)))]
      
      [(unordered-list (list tss ...)) `((ul () ,@(map ts->li tss)))]))
  
  (define (ts->li ts)
    `(li () ,@(append* (map text->xexpr ts))))
  
  (define (text->xexpr t)
    ((text->xexpr-halp (state 0)) t))
  
  (define ((text->xexpr-halp st) t)
  (define (tag-all st tag ts)
    `((,@tag ,@(append* (map (text->xexpr-halp st) ts)))))
    
    (match t
      [(? string?) (list t)]
      [(link/url url ts) (tag-all st `(a ([href ,url])) ts)]
      [(link/internal url ts) (tag-all st `(a ([href ,(relative-url from url)])) ts)]
    [(emphasis ts) (tag-all st '(em ()) ts)]
      [(strong ts) (tag-all st '(strong ()) ts)]
      [(code ts) (tag-all st '(span ([class "code"])) ts)]
      [(code-word ts) (tag-all st '(span ([class "codew"])) ts)]
      [(quoted ts) (quot-halp st ts)]))

  (define (quot-halp st ts)
    (define q-lvl (state-quote-level st))
    (define  q-start (if (even? q-lvl) "“" "‘"))
    (define  q-end (if (even? q-lvl) "”" "’"))
    
    `(,q-start
      ,@(append* (map (text->xexpr-halp (state (+ q-lvl 1))) ts))
      ,q-end))
  
  (text-piece->xexpr p))
#lang racket
(provide write-html-file
         ->html-xexpr
         relative-url)

(require (only-in xml xexpr->string))

(define (write-html-file path x)
  (make-parent-directory* path)
  
  (call-with-output-file path #:exists 'truncate
    (λ (out)
      (display (~a "<!DOCTYPE HTML>\n" (xexpr->string x))
               out))))

(define (relative-url from to)
  (define res (path->string (find-relative-path (path-only from) to)))
                  
  (string-replace res  "\\" "/"))
(require racket/trace) (trace relative-url)

(define (nav from)
  `(div ((class "nav"))
        (a ((class "navlink") (href ,(relative-url from "/index.html")))
           (div ((class "navlink")) "λ"))))

(define (title->head from title)
  `(head (meta ((charset "UTF-8"))
               (title ,title)
               (link ((rel "stylesheet") (href ,(relative-url from "/styles.css")))))))

(define (->html-xexpr from name content)
  `(html ,(title->head from name)
            (body (div ((class "content"))
                       (div ((class "navinfo")) ,(nav from))
                       (div ((class "text"))
                            ,@content)))))
#lang racket
(provide write-html-file
         ->html-xexpr
         ->lambs-html-xexpr
         relative-url
         editor-html-xexpr)

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

(define (lambs-js-stuff from)
  `((script ((data-main ,(relative-url from "/lambstuff/reqmain")) (src ,(relative-url from "/lambstuff/require.js"))))
    (script ((src ,(relative-url from "/lambstuff/monaco-editor/min/vs/loader.js"))))
    (script ((src ,(relative-url from "/lambstuff/stuff.js"))))))

(define (->lambs-html-xexpr from name content)
  `(html ,(title->head from name)
            (body ((onresize "refreshEditors()"))
                  (div ((class "content"))
                       (div ((class "navinfo")) ,(nav from))
                       (div ((class "text"))
                            ,@content))
                  ,@(lambs-js-stuff from))))

(define (editor-html-xexpr from name content)
  `(html ,(title->head from name)
            (body ((onresize "refreshEditors()"))
                  (div ((class "editor") (name "lambs")) ,content)
                  ,@(lambs-js-stuff from))))
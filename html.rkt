#lang racket
(provide write-html-file
         ->html-xexpr
         ->lambs-html-xexpr
         relative-url
         editor-html-xexpr
         text-piece->html)

(require (only-in xml xexpr->string)
         "structs.rkt")

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



(struct tstate (quote-level) #:transparent)

(define ((text-piece->html from) p)
  
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
    ((text->xexpr-halp (tstate 0)) t))

  (define (ref->string r)
    (match r
      [(ref/url url) url]
      [(ref/internal url) (relative-url from url)]))
  
  (define ((text->xexpr-halp st) t)
    (define (tag-all st tag ts)
      `((,@tag ,@(append* (map (text->xexpr-halp st) ts)))))
    
    (match t
      [(? string?) (list t)]
      [(link r ts) (tag-all st `(a ([href ,(ref->string r)])) ts)]
      [(emphasis ts) (tag-all st '(em ()) ts)]
      [(strong ts) (tag-all st '(strong ()) ts)]
      [(code ts) (tag-all st '(span ([class "code"])) ts)]
      [(code-word ts) (tag-all st '(span ([class "codew"])) ts)]
      [(quoted ts) (quot-halp st ts)]
      [(txts ts) (append* (map (text->xexpr-halp st) ts))]))

  (define (quot-halp st ts)
    (define q-lvl (tstate-quote-level st))
    (define  q-start (if (even? q-lvl) "“" "‘"))
    (define  q-end (if (even? q-lvl) "”" "’"))
    
    `(,q-start
      ,@(append* (map (text->xexpr-halp (tstate (+ q-lvl 1))) ts))
      ,q-end))
  
  (text-piece->xexpr p))
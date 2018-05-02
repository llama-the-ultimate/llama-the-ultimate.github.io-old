#lang at-exp racket
(require (only-in xml xexpr->string))

(define (title->head title)
  `(head (meta ((charset "UTF-8"))
               (title ,title)
               (link ((rel "stylesheet") (href "styles.css"))))))

(define (->html-xexpr name content)
  `(html ,(title->head name)
         (body (svg ((class "hidden"))
                    (symbol ((id "slideicon"))
                            (rect ((x "3") (y "3") (width "48") (height "27") (style "fill:rgb(255,255,255);stroke-width:2;stroke:rgb(0,0,0)")))))
               (div ((id "clock") (class "clock")))
               (div ((class "outer"))
                    (div ((class "content") (id "for-slides"))
                         (p ()
                            "okay so these are slides. "
                            "if you have a javascript enabled, you should be able to click on one of the little "
                            (svg ((class "slidelink") (slidename "0") (width "54") (height "33")) (use ((xlink:href "#slideicon"))))
                            "-symbols in order to view like one slide. "
                            "and then press a and d keys to move back and forward through them. "
                            "(and press escape to like exit slide mode.) "
                            "(also also press t to toggle display of current time)")
                         ,@content))
               (script ((src "stuff.js"))))))

(define (write-html-file path x)
  (make-parent-directory* path)
  
  (call-with-output-file path #:exists 'truncate
    (λ (out)
      (display (~a "<!DOCTYPE HTML>\n" (xexpr->string x))
               out))))

(define (img s)
  `(div ((class "image"))
        (img ((src ,s)))))

(define (slide name content)
  `(div ()
        (div ()
             ,(lnk (format "#~a" name))
             " "
             (svg ((class "slidelink") (slidename ,name) (width "54") (height "33")) (use ((xlink:href "#slideicon")))))
        (div ((class "slide") (id ,name))
             ,@content)))

(define ((tag-all tag) xs)
  (match tag
    [`(,name ,attrs)
     (map (λ (x) `(,name ,attrs ,@x)) xs)]))

(define (make-slides xs)
  (add-between (for/list ([x xs]
                          [i (in-naturals)])
                 (slide (~a i) x))
               '(hr ())))

(define (listy x)
  (if (list? x)
      x
      (list x)))

(define (lines xs)  
  (map (λ (x) `(p () ,@x))
       (map listy xs)))

(define (sld #:title [title #f] . stuff)
  `((div ((class "nothai"))
         ,@(if title `((h1 () ,@(listy title))) '())
         ,@(lines stuff))))

(define (imgsld #:title [title #f] image . xs)
  `((div ((class "nothai"))
         ,@(if title `((h1 () ,@(listy title))) '())
         ,(img image)
         ,@(lines xs))))

(define (lnk r [s r])
  `(a ([href ,r]) ,s))



(define beginning/end
  (sld #:title "lambda calculus beep boop"
       `("recursion: "
         ,(lnk "http://llama-the-ultimate.org/slides/flatmap2018"))
       `("we: "
         ,(lnk "https://twitter.com/einarwh" "@einarwh")
         ", "
         ,(lnk "https://twitter.com/JonasWinje" "@JonasWinje"))))

(define all-slides
  (list

   beginning/end
    
   (sld #:title "hi hello")

   (sld #:title "traditional syntax")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "x") (td () "variable"))
                 (tr () (td ()) (td () "λx.u") (td () "abstraction"))
                 (tr () (td ()) (td () "u1 u2") (td () "application")))))

   (sld #:title "de bruijn index")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "n") (td () "variable"))
                 (tr () (td ()) (td () "λu") (td () "abstraction"))
                 (tr () (td ()) (td () "u1 u2") (td () "application")))))

   (sld #:title "beep boop")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "boop b") (td () "variable"))
                 (tr () (td ()) (td () "beep u") (td () "abstraction"))
                 (tr () (td ()) (td () "pling u1 u2") (td () "application"))))
          
        '((table ()
                 (tr () (td () "Boops b ::=") (td () "bap") (td () "bap"))
                 (tr () (td ()) (td () "boop b") (td () "boop")))))

   (sld #:title "okay bye")
   beginning/end))

(write-html-file
 "index.html"
 (->html-xexpr
  "some slides"
  (make-slides all-slides)))

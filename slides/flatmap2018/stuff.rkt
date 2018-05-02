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

(define all-slides
  (list

   (sld #:title "lambda calculus beep boop"
       `("recursion: "
         ,(lnk "http://llama-the-ultimate.org/slides/flatmap2018"))
       `("we: "
         ,(lnk "https://twitter.com/einarwh" "@einarwh")
         ", "
         ,(lnk "https://twitter.com/JonasWinje" "@JonasWinje")))
    
   (sld #:title "hi hello")

   (sld #:title "blah"
        "this is mostly about syntax")

   (sld #:title "traditional syntax")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "x") (td () "variable"))
                 (tr () (td ()) (td () "λx.u") (td () "abstraction"))
                 (tr () (td ()) (td () "u1 u2") (td () "application")))))

   (sld "replace references to parameter with argument"
        "(λa.λb.λc.c a b) foo bar quux"
        "(λb.λc.c foo b) bar quux"
        "(λc.c foo bar) quux"
        "quux foo bar")

   (sld #:title "some lambdas"
        "0 is λf.λx.x"
        "1 is λf.λx.f x"
        "2 is λf.λx.f (f x)"
        "3 is λf.λx.f (f (f x))"
        "5 is λf.λx.f (f (f (f (f x))))"
        "and so on")

   (sld #:title "some lambdas"
        "+ is λa.λb.λf.λx.a f (b f x)"
        "(f applied a times to f applied b times to x)"
        "* is λa.λb.λf.λx.a (b f) x"
        "(f applied b times a times to x)")

   (sld #:title "can try"
        `(,(lnk "../../lambdas.html" "evaluator"))
        "2 is λf.λx.f (f x)"
        "3 is λf.λx.f (f (f x))"
        "+ is λa.λb.λf.λx.a f (b f x)"
        "* is λa.λb.λf.λx.a (b f) x")
        
   (sld #:title "can try"
        `(,(lnk "../../lambdas.html" "evaluator"))
        "2 is λf.λx.f (f x)"
        "3 is λf.λx.f (f (f x))"
        "+ is λa.λb.λf.λx.a f (b f x)"
        "* is λa.λb.λf.λx.a (b f) x"
        ""
        "2 + 3 is (λa.λb.λf.λx.a f (b f x)) (λf.λx.f (f x)) (λf.λx.f (f (f x)))")
        
   (sld #:title "can try"
        `(,(lnk "../../lambdas.html" "evaluator"))
        "2 is λf.λx.f (f x)"
        "3 is λf.λx.f (f (f x))"
        "+ is λa.λb.λf.λx.a f (b f x)"
        "* is λa.λb.λf.λx.a (b f) x"
        ""
        "2 * 3 is (λa.λb.λf.λx.a (b f) x) (λf.λx.f (f x)) (λf.λx.f (f (f x)))")

   (sld #:title "okay")
   
   (sld "is traditional"        
        "possibly shoutability concerns"
        "variables can be named almost anything"
        "is the untyped lambda calculus sound?"
        "has greek letters in it (hci?)"
        "parentheses"
        "variable capture thing")

   (sld #:title "variable capture thing"
        "λy.(λx.λy.x) y")

   (sld #:title "variable capture thing"
        "λy.(λx.λy.x) y"
        "λy.(λy.y)"
        "oh no")
   
   (sld #:title "variable capture thing"
        "λy.(λx.λy.x) y"
        "rename inner y before reducing"
        "λy.(λx.λy2.x) y"
        "λy.λy2.y")

   (sld #:title "de bruijn index")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "n") (td () "variable"))
                 (tr () (td ()) (td () "λu") (td () "abstraction"))
                 (tr () (td ()) (td () "u1 u2") (td () "application")))))

   (imgsld #:title "λz. (λy. y (λx. x)) (λx. z x)"
           "imgs/debruijn.svg")

   (sld #:title "variable capture thing"
        "λy.(λx.λy.x) y"
        "λ(λλ2) 1")

   (sld #:title "variable capture thing"
        " λ(λλ2) 1"
        "λλ2")

   (sld #:title "some lambdas"
        "0 is λλ1"
        "1 is λλ2 1"
        "2 is λλ2 (2 1)"
        "3 is λλ2 (2 (2 1))"
        "5 is λλ2 (2 (2 (2 (2 1))))"
        "and so on")

   (sld #:title "some lambdas"
        "+ is λλλλ4 2 (3 2 1)"
        "(um)"
        "* is λλλλ4 (3 2) 1"
        "(uh)")

   (sld #:title "2 + 3"
        "(λλλλ4 2 (3 2 1)) (λλ2 (2 1)) (λλ2 (2 (2 1)))"
        "(λλλ(λλ2 (2 1)) 2 (3 2 1)) (λλ2 (2 (2 1)))"
        "λλ(λλ2 (2 1)) 2 ((λλ2 (2 (2 1))) 2 1)"
        "λλ(λ3 (3 1)) ((λλ2 (2 (2 1))) 2 1)"
        "λλ2 (2 ((λλ2 (2 (2 1))) 2 1))"
        "λλ2 (2 ((λ3 (3 (3 1))) 1))"
        "λλ2 (2 (2 (2 (2 1))))")

   (sld #:title "2 * 3"
        "(λλλλ4 (3 2) 1) (λλ2 (2 1)) (λλ2 (2 (2 1)))"
        "(λλλ(λλ2 (2 1)) (3 2) 1) (λλ2 (2 (2 1)))"
        "λλ(λλ2 (2 1)) ((λλ2 (2 (2 1))) 2) 1"
        "λλ(λ(λλ2 (2 (2 1))) 3 ((λλ2 (2 (2 1))) 3 1)) 1"
        "λλ(λλ2 (2 (2 1))) 2 ((λλ2 (2 (2 1))) 2 1)"
        "λλ(λ3 (3 (3 1))) ((λλ2 (2 (2 1))) 2 1)"
        "λλ2 (2 (2 ((λλ2 (2 (2 1))) 2 1)))"
        "λλ2 (2 (2 ((λ3 (3 (3 1))) 1)))"
        "λλ2 (2 (2 (2 (2 (2 1)))))")

   (sld #:title "anyway"
        "arithmetic instead of variable capture"        
        "subtract 1 from free variables in the function"
        "number of parameter-variable in function increases with depth in syntax tree"
        "add depth to free variables in argument when replacing")

   (sld "fewer possible variable names"
        "still uses greek letters"
        "is the untyped lambda calculus sound??"
        "also still parentheses"
        "maths")
   
   (sld #:title "beep boop")
   (sld '((table ()
                 (tr () (td () "Exp u ::=") (td () "boop b") (td () "variable"))
                 (tr () (td ()) (td () "beep u") (td () "abstraction"))
                 (tr () (td ()) (td () "pling u1 u2") (td () "application"))))
          
        '((table ()
                 (tr () (td () "Boops b ::=") (td () "bap") (td () "bap"))
                 (tr () (td ()) (td () "boop b") (td () "boop")))))

   (sld #:title "so the identity function is beep boop bap"
        "nice")

   (sld #:title "some beep boops"
        "0 is beep beep boop bap"
        "1 is beep beep pling boop boop bap boop bap"
        "2 is beep beep pling boop boop bap pling boop boop bap boop bap"
        "3 is beep beep pling boop boop bap pling boop boop bap pling boop boop bap boop bap"
        "5 is beep beep pling boop boop bap pling boop boop bap pling boop boop bap pling boop boop bap pling boop boop bap boop bap"
        "and so on")
   
   (sld #:title "some beep boops"
        "+ is beep beep beep beep pling pling boop boop boop boop bap boop boop bap pling pling boop boop boop bap boop boop bap boop bap"
        "* is beep beep beep beep pling pling boop boop boop boop bap pling boop boop boop bap boop boop bap boop bap")
   
   (sld #:title "2 + 3"
        "pling pling beep beep beep beep pling pling boop boop boop boop bap boop boop bap pling pling boop boop boop bap boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap pling boop boop bap boop bap")
   
   (sld #:title "can try"
        `(,(lnk "beep-boop/0-beops.html" "an evaluator!")))

   (sld #:title "good stuff")

   (sld #:title "okay"
        `("there's ",(lnk "beep-boop/1-beops-bru.html" "another evaluator")))

   (sld `("and ",(lnk "beep-boop/2-beops-bru-lamb.html" "another one")))

   (sld #:title "2 + 3"
        "pling pling beep beep beep beep pling pling boop boop boop boop bap boop boop bap pling pling boop boop boop bap boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap pling boop boop bap boop bap")
   
   (sld #:title "2 * 3"
        "pling pling beep beep beep beep pling pling boop boop boop boop bap pling boop boop boop bap boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap boop bap beep beep pling boop boop bap pling boop boop bap pling boop boop bap boop bap")

   (sld #:title "so")
   
   (sld "no parentheses"
        "a small set of not very difficult words"
        "solves hci issues by being intuitive for both humans and computers")
   
   (sld #:title "“making illegal states unrepresentable”"
        "we"
        "accept beep, boop, pling"
        "or accept boop, bap"
        "or are done")

   (sld #:title "“making illegal states unrepresentable”"
        "easy to keep track of how many expressions we need"
        "starts at 1"
        "increases by 1 when pling"
        "decreases by 1 when boop-bap")

   (sld #:title "neat")

   (sld #:title "the beep boop software suite, enterprise addons")

   (sld #:title "is the untyped lambda calculus sound???")
   
   (sld #:title "does the untyped lambda calculus make sound?????")

   (sld #:title "does the untyped lambda calculus make sound?????"
        `(,(lnk "beep-boop/4-sounds.html" "noisy editor")))

   (sld #:title "replace the keyboard with a keyboard")

   (sld #:title "more soundness"
        `(,(lnk "beep-boop/5-playback.html" "noisy evaluator")))

   (sld #:title "also voice recognition")

   (sld #:title "syntax colouring"
        `(,(lnk "beep-boop/6-rectangles.html" "graphical evaluator")))
        
   (sld #:title "okay bye"
        `(,(lnk "beep-boop/7-only-rectangles.html" "evaluator"))
        `((pre () ,@@list{
 notes = makeNotes(x =>[@"{" val: x * 1.2, time: 0.7 @"}", @"{" val: x, time: 0.3 @"}"], vol,[400, 460, 515, 550, 800, 250]);
})))))

(write-html-file
 "index.html"
 (->html-xexpr
  "some slides"
  (make-slides all-slides)))

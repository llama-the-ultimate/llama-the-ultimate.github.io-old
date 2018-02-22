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



(define lamb1-txt (sld #:title "(λa.a (foo a)) bar"))

(define lamb1 (imgsld #:title "(λa.a (foo a)) bar"
                      "imgs/lamb1.svg"))

(define lamb1-ps (imgsld #:title "(λa.a (foo a)) bar"
                         "imgs/lamb1.svg"
                         '((pre () "App (Lam \"a\" (App (Var \"foo\") (Var \"a\"))) (Var \"bar\")"))))

(define lamb1-ps-match (sld #:title "(λa.a (foo a)) bar"
                            "given"
                            '((pre () "App (Lam \"a\" (App (Var \"foo\") (Var \"a\"))) (Var \"bar\")"))
                            "the match on"
                            '((pre () "redex (App (Lam p b) a) = ..."))
                            "should match and like bind variables"
                            `((pre () ,@@list{
 p = "a"
 b = App (Var "foo") (Var "a")
 a = (Var "bar")
 }))))

(define paren (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Parse.purs#L90-L91" "Parse.purs"))
                   `((pre ()
                          ,@@list{
 paren :: forall a b m.StringLike a => Monad m => ParserT a m b -> ParserT a m b
 paren x = between (string "(") (string ")") x
 }))))

(define lamb1-redex (imgsld #:title "(λa.a (foo a)) bar"
                            "imgs/lamb1-redex.svg"))

(define lamb1-redex2 (imgsld #:title "(λa.a (foo a)) bar"
                            "imgs/lamb1-redex2.svg"))

(define lamb1-redex3 (sld #:title "(λa.a (foo a)) bar"
                            "argument: bar"
                            "parameter: a"
                            "body:"
                            `(,(img "imgs/lamb1-body.svg"))))

(define lamb1-body (imgsld #:title "a (foo a)"
                           "imgs/lamb1-body.svg"))

(define lamb1-res (imgsld #:title "bar (foo bar)"
                          "imgs/lamb1-res.svg"))

(define as-if-by-hand (imgsld #:title "as if by hand"
                              "imgs/by-hand.jpg"))
(define as-if-by-hand2 (imgsld #:title "as if by hand"
                               "imgs/by-hand2.jpg"))

(define beginning/end
  (sld #:title "what, if anything, is a llama?"
       `("recursion: "
         ,(lnk "http://llama-the-ultimate.org/slides/lambdadays2018"))
       `("me: "
         ,(lnk "https://twitter.com/JonasWinje" "@JonasWinje")
         ", "
         ,(lnk "https://github.com/Glorp" "Glorp"))))

(define (hai l1 l2 l3)
  `((div ((class "hai"))
         ,@(add-between (list l1 l2 l3) '(br ())))))

(define all-slides
  (list
   (hai "majestic wool-beast"
        "camelid in sheep’s clothing"
        "not an alpaca")

   beginning/end
   
   (hai "mostly proper slides"
        "am not used to proper slides"
        "hopes for no mistakes")
    
   (sld #:title "hi hello welcome to object oriented days")

   (sld #:title "part 0 is intro, background")

   (hai "a little purescript"
        "some general fp things?"
        "web dev wiring stuff")
   
   (imgsld "imgs/onegoodidea.png"
           (list "(from " (lnk "https://www.youtube.com/watch?v=XJ0CyOVTSV8" "interview with Dylan Carlson")
                 " (the guitarist (who plays in Earth)))")
           "— I joke about: I have only had one good idea, and I’ve been running with it ever since."
           "— What is that?"
           "— To play slow and repeat yourself.")
   
   (hai "a good idea"
        "to have evaluator"
        "in text editor")
   as-if-by-hand
   (sld #:title "btw smalltalk")

   (sld `((pre () ,@@list{
 (λa.λb.a ((λa.λb.a (λn.λf.λx.f (n f x)) b) b) (λf.λx.x)) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.f (f (f (f (f (f (f (f (f (f x))))))))))
 (λb.(λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) b) (λf.λx.x)) (λf.λx.f (f (f (f (f (f (f (f (f (f x))))))))))
 (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x))))))))))) (λf.λx.x)
 (λx.(λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) x)))))))))) (λf.λx.x)
 (λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))
 (λb.(λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λn.λf.λx.f (n f x)) b) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))
 (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))
 (λx.(λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))
 (λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))))))
 λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))))) f x)
 λf.λx.f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x)) f x)
 λf.λx.f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x)) x)
 λf.λx.f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x))
 λf.λx.f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x)) f x))
 λf.λx.f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x)) x))
 λf.λx.f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x)))
 λf.λx.f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x)) f x)))
 λf.λx.f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x)) x)))
 λf.λx.f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x))))
 λf.λx.f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))) f x)) f x))))
 λf.λx.f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))) f x)) x))))
 λf.λx.f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))) f x)))))
 λf.λx.f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))) f x)) f x)))))
 λf.λx.f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))) f x)) x)))))
 λf.λx.f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))) f x))))))
 λf.λx.f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))) f x)) f x))))))
 λf.λx.f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))) f x)) x))))))
 λf.λx.f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))) f x)))))))
 λf.λx.f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))) f x)) f x)))))))
 λf.λx.f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))) f x)) x)))))))
 λf.λx.f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))) f x))))))))
 λf.λx.f (f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))) f x)) f x))))))))
 λf.λx.f (f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))) f x)) x))))))))
 λf.λx.f (f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))) f x)))))))))
 λf.λx.f (f (f (f (f (f (f (f (f ((λf.λx.f ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x)) f x)))))))))
 λf.λx.f (f (f (f (f (f (f (f (f ((λx.f ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x)) x)))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λb.(λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λn.λf.λx.f (n f x)) b) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λx.(λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))))) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x)) f x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x)) x))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))))) f x)))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x)) f x)))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x)) x)))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))))) f x))))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x)) f x))))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x)) x))))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f (f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x))))))))))))))) f x)))))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f (f ((λf.λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))) f x)) f x)))))))))))))
 λf.λx.f (f (f (f (f (f (f (f (f (f (f (f (f ((λx.f ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λn.λf.λx.f (n f x)) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) ((λa.λb.a (λn.λf.λx.f (n f x)) b) (λf.λx.f (f (f (f (f (f (f (f (f (f x)))))))))) (λf.λx.x)))))))))))))) f x)) x)))))))))))))
 })))
   
   (hai "we was here last year"
        "someone asked us a question"
        "answer was awkward")

   (hai "a sublime plugin"
        "emacs and standard ml"
        "emacs and racket")

   (hai "less awkward answer"
        "would be to link to something"
        "that ran in browser")

   (hai "(while a link sounds good"
        "I don’t know too much about"
        "web development)")
   
    (sld #:title "demo a little bit"
         `(,(lnk "http://llama-the-ultimate.org/lists/lambs.html")))
    
    (sld #:title "tech")
    (hai "know standard ml"
         "a bit of haskell and elm"
         "purescript is a thing")

    (hai "and I know how to"
         "do basic HTML"
         "and some CSS")

    (hai "monaco is a"
         "code editor for browser"
         "(used in vs code)")

    (sld #:title "part 1 is purescript then")

    (hai "purescript is language"
         "with sensible ml things"
         "and weird haskellisms")
    
    (hai "getting started page"
         "is good for getting started"
         "(that is what it’s for)")
    (imgsld #:title (list (lnk "https://github.com/purescript/documentation/blob/master/guides/Getting-Started.md" "at purescript github"))
            "imgs/gettingstarted.png")
    (imgsld #:title (list (lnk "https://github.com/purescript-contrib/pulp" "also pulp docs"))
            "imgs/pulp.png")

    (hai "atom with plugins"
         "draws dotted lines under stuff"
         "and colours some words")

    (imgsld #:title `(,(lnk "https://atom.io/packages/ide-purescript" "ide-purescript")
                      " and "
                      ,(lnk "https://atom.io/packages/language-purescript" "language-purescript"))
            "imgs/atom1.png")
    (imgsld #:title `(,(lnk "https://atom.io/packages/ide-purescript" "ide-purescript")
                      " and "
                      ,(lnk "https://atom.io/packages/language-purescript" "language-purescript"))
            "imgs/atom2.png")
    (imgsld #:title `(,(lnk "https://atom.io/packages/ide-purescript" "ide-purescript")
                      " and "
                      ,(lnk "https://atom.io/packages/language-purescript" "language-purescript"))
            "imgs/atom3.png")
    (imgsld #:title `(,(lnk "https://atom.io/packages/ide-purescript" "ide-purescript")
                      " and "
                      ,(lnk "https://atom.io/packages/language-purescript" "language-purescript"))
            "imgs/atom4.png")

    (sld #:title "wait part 1 is also lambda calculus!")
    (hai "formal system in"
         "mathematical logic"
         "for computation")

    lamb1-txt
    
    (hai "lambda abstraction"
         "and function application"
         "and variables")

    lamb1

    (sld '((table ()
                  (tr () (td () "Exp u ::=") (td () "x") (td () "variable"))
                  (tr () (td ()) (td () "λx.u") (td () "abstraction"))
                  (tr () (td ()) (td () "u1 u2") (td () "application")))))

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Term.purs#L12-L15" "Term.purs"))
         `((pre ()
                ,@@list{
 data Term
   = Var String
   | Lam String Term
   | App Term Term
 })))

    lamb1-ps

    (sld #:title "parsing")
    (imgsld #:title `(,(lnk "https://pursuit.purescript.org/packages/purescript-parsing" "purescript-parsing"))
            "imgs/purescript-parsing.png")

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Parse.purs#L57-L63" "Parse.purs"))
         `((pre ()
                ,@@list{
 lam :: Parser String Term -> Parser String Term
 lam x = do
   _ <- (string "λ") <|> (string "\\")
   p <- identifier
   _ <- (string ".")
   b <- x
   pure (Lam p b)
 })))

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Parse.purs#L23-L24" "Parse.purs"))
         `((pre ()
                ,@@list{
 reserved :: Set.Set Char
 reserved = Set.fromFoldable [':', '\\', '≜', 'λ', ' ', '\n', '\t', '.', '(', ')']
 }))
         `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Parse.purs#L35-L36" "Parse.purs"))
         `((pre ()
                ,@@list{
 identifier :: Parser String String
 identifier = many1 (satisfy (\x -> not (Set.member x reserved))) >>= pure <<< listString
 })))

    paren
    
    (sld #:title "unparsing")
    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Unparse.purs" "Unparse.purs"))
         `((pre ()
                ,@@list{
 pstring :: String -> String
 pstring s = "(" <> s <> ")"

 argstring :: Term -> String
 argstring (Var s) = s
 argstring t = pstring (unparse t)

 -- | uns the parse
 unparse :: Term -> String
 unparse (Lam p b) = "λ" <> p <> "." <> unparse b
 unparse (App (Lam p b) a) = pstring (unparse (Lam p b)) <> " " <> argstring a
 unparse (App f a) = unparse f <> " " <> argstring a
 unparse (Var s) = s
 })))

    (sld #:title "computation")
    (hai "(we do not look up"
         "variables in scope but"
         "use substitution)")
    (imgsld "imgs/env-vs-subst.jpg")
    
    as-if-by-hand
    as-if-by-hand2
    
    (imgsld #:title "(btw I like substitution)"
            "imgs/sicp.jpg"
            `(,(lnk "https://mitpress.mit.edu/sicp/full-text/book/book-Z-H-10.html#%_sec_1.1.5" "(the substitution model for procedure application)"))
            `(,(lnk "https://mitpress.mit.edu/sicp/full-text/book/book-Z-H-20.html#%_sec_3.1.3" "(the costs of introducing assignment)")))
    
    (sld #:title "reducible expressions")
    (hai "an application"
         "of a lambda abstraction"
         "to an expression")

    lamb1

    lamb1-redex

    (sld #:title "beta reduction")
    (hai "lambda-body with"
         "argument substituted"
         "for parameter")

    lamb1-redex2
    lamb1-redex3
    
    lamb1-body
    (sld #:title "swoosh")
    lamb1-res

    (sld #:title "so")
    lamb1
    lamb1-body
    lamb1-res

    (sld #:title "finding a reducible expression")
    lamb1
    lamb1-redex
    lamb1-redex2

    (hai "assuming we have"
         "data structures and functions"
         "for searching for terms")

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Term.purs#L28" "Term.purs"))
         `((pre () "data Found a = Found TermPath a"))
         `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Term.purs#L53-L66" "Term.purs"))
         `((pre () "findTerm :: forall a. (Term -> Maybe a) -> Term -> Maybe (Found a)"))
         `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Term.purs#L73-L73" "Term.purs"))
         `((pre () "fillTerm :: TermPath -> Term -> Term")))
    
    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Subst.purs#L13" "Subst.purs"))
         '((pre () "data Redex = Redex Term String Term"))
         `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Subst.purs#L21-L23" "Subst.purs"))
         `((pre () ,@@list{
 redex :: Term -> Maybe Redex
 redex (App (Lam p b) a) = Just (Redex a p b)
 redex _ = Nothing
 })))

    lamb1-ps-match

    (sld #:title "substitution (swoosh)")
    lamb1
    lamb1-body
    lamb1-res

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambs/blob/v0.3.0/src/Lambs/Subst.purs#L26-L32" "Subst.purs"))
         `((pre () ,@@list{
 subst :: Redex -> Term
 subst (Redex arg param body) = halp body
   where
     halp :: Term -> Term
     halp (App f a) = App (halp f) (halp a)
     halp (Lam p b) = Lam p (if p == param then b else halp b)
     halp (Var s) = if s == param then arg else (Var s)
 })))

    (hai "(additional stuff"
         "toplevel definitions"
         "alpha renaming)")

    (imgsld #:title `("btw there’s a " ,(lnk "https://www.youtube.com/watch?v=oaU1aiBuBRE ""talk"))
            "imgs/livelamb-beta.svg")
    (imgsld #:title `("btw there’s a " ,(lnk "https://www.youtube.com/watch?v=oaU1aiBuBRE ""talk"))
            "imgs/livelamb-design.svg")
    
    (sld #:title `("also btw " ,(lnk "https://existentialtype.wordpress.com/2011/03/15/boolean-blindness/" "boolean blindness")))
    (hai "it can be good to"
         "return the stuff you need for"
         "next part of program")
    (sld "often more good:"
         '((pre () "data Redex = Redex Term String Term"))
         `((pre () "redex :: Term -> Maybe Redex"))
         `((pre () "subst :: Redex -> Term"))
         "possibly less good:"
         `((pre () "redex :: Term -> Boolean")))
    (sld "unsurprisingly"
         "better A and B leads to"
         "better A -> B")
    (sld #:title "(I totally did less good thing in earlier version)"
         `(,(lnk "https://github.com/Glorp/Elmbdas/blob/19b33141b478869ae798bb877c52ee8de98b2967/Eval.elm#L44-L46" "Eval.elm"))
         `((pre () ,@@list{
 reducible t = case t of
                 (App (Lam _ _) _) -> True
                 _                 -> False
 }))
         "leads to non-exhaustive pattern match later on"
         `(,(lnk "https://github.com/Glorp/Elmbdas/blob/19b33141b478869ae798bb877c52ee8de98b2967/Eval.elm#L77" "Eval.elm"))
         `((pre () "reduceRename0 t (App (Lam p b) a) = ...")))

    (sld #:title "part 2 is wiring? assembly? architecture?")
    (hai "pure functions inside"
         "layer with state and effects"
         "surrounding the core")

    (sld #:title "io, eff")
    (imgsld #:title "modernized algol"
            "imgs/pfpl.jpg")
    
    (imgsld "imgs/stuff.jpg")

    (hai "core domain is done"
         "reasonably properly"
         "(other parts less so)")

    (imgsld #:title "core domain bit: purescript-lambs"
            "imgs/stuff-ps-lambs.jpg"
            `(,(lnk "https://github.com/Glorp/purescript-lambs" "github"))
            `(,(lnk "https://pursuit.purescript.org/packages/purescript-lambs" "pursuit")))
    
    (hai "implementation"
         "of a lambda calculus"
         "evaluator")

    (imgsld #:title "interop? anti-corruption? purescript-lambness"
            "imgs/stuff-ps-lambness.jpg"
            `(,(lnk "https://github.com/Glorp/purescript-lambness" "github")))

    (hai "pulp browserify"
         "--optimise --standalone lambs"
         "--to lambs.js")

    (sld `(,(lnk "https://github.com/Glorp/purescript-lambness/blob/64301ec83aa32f5434436edd2993538f027a319b/src/Main.purs#L14-L15" "Main.purs"))
         `((pre ()
                ,@@list{
 parse :: String -> Maybe Toplevel
 parse s = Parse.parseTop s
 }))
         `(,(lnk "https://github.com/Glorp/purescript-lambness/blob/64301ec83aa32f5434436edd2993538f027a319b/src/Main.purs#L22-L26" "Main.purs"))
         `((pre ()
                ,@@list{
 step :: Maybe Toplevel -> String
 step Nothing = ":("
 step (Just (Def (Define s _))) = s <> " is defined :)"
 step (Just (Undef (Undefine s))) = s <> " is undefined :o"
 step (Just (Trm term)) = execStr (Just (stepExec term))
 }))
         `(,(lnk "https://github.com/Glorp/purescript-lambness/blob/64301ec83aa32f5434436edd2993538f027a319b/src/Main.purs#L42-L44" "Main.purs"))
         `((pre ()
                ,@@list{
 isJust :: forall a. Maybe a -> Boolean
 isJust Nothing = false
 isJust _ = true
 })))
    (sld "we can test some stuff in js console"
         '((pre () "lambs.step(lambs.parse(\"(λx.λy.y x) foo\"))"))
         '((pre () "lambs.isJust(lambs.parse(\"(λx.λy.y x foo\"))")))

    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/reqmain.js" "reqmain.js"))
         `((pre ()
               ,@@list{
 var lambs;
 var defs;
 var getDefs;
 var updateDefs;

 require(['lambs'], function (foo) @"{"
     lambs = foo;

     defs = lambs.noDefs;
     updateDefs = function (d) @"{"
       defs = lambs.updateDefs(d)(defs);
     @"}";
 @"}");
 })))

    (imgsld #:title "the mo in monaco stands for moo, the co for cow"
                 "imgs/stuff-monaco.jpg")
                 
    (imgsld #:title `(,(lnk "https://github.com/Microsoft/monaco-editor" "monaco"))
            "imgs/monaco.png")

    (hai "downloaded a thing"
         "put it somewhere within reach"
         "require bit me")
    
    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/stuff.js#L1" "stuff.js"))
         `((pre () "require.config({ paths: { 'vs': 'monaco-editor/min/vs' }});")))

    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/stuff.js#L3-L19" "stuff.js"))
         `((pre ()
                ,@@list{
 var startMonaco = function() @"{"

   var res = [];
   var elems = document.getElementsByName("lambs");
   require(['vs/editor/editor.main'], function() @"{"

     for (var i = 0; i < elems.length; i++) @"{"
       var elem = elems[i];
       if (elem.getAttribute("prelude") === "true") @"{"
         res.push(startPreluditor(elem));
       @"}" else @"{"
         res.push(startEditor(elem));
       @"}"

     @"}"@"}");
     return res;
 @"}";
 })))

    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/stuff.js#L58-L66" "stuff.js"))
         `((pre ()
                ,@@list{
 var content = element.textContent;
 element.textContent = "";

 var editor = monaco.editor.create(element, @"{"
     value: content,
     lineNumbers: false,
     quickSuggestions: false,
     mouseWheelZoom: true
 @"}");
 })))
    
    
    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/stuff.js#L68-L74" "stuff.js"))
         `((pre ()
                ,@@list{
    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.KEY_L], function() @"{"
        var range = editor.getSelection();
        var id = @"{" major: 1, minor: 1 @"}";
        var text = 'λ';
        var op = @"{"identifier: id, range: range, text: text, forceMoveMarkers: true@"}";
        editor.executeEdits("lambs", [op]);
 @"}");})))

    (sld `(,(lnk "https://github.com/Glorp/glorp.github.io/blob/1034bce5320baf182b5feef9395d348e4eef987e/lambstuff/stuff.js#L84-L101" "stuff.js"))
         `((pre ()
                ,@@list{
    editor.addCommand([monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter], function() {
        var selection = editor.getSelection();
        var line = selection.positionLineNumber;
        var model = editor.getModel();
        var s = model.getLineContent(line);
        var pos = new monaco.Position(line, s.length + 1);
        editor.setPosition(pos);
        var range = editor.getSelection();
        var id = @"{" major: 1, minor: 1 @"}";
        var parsed = lambs.parse(s);
        updateDefs(parsed);
        var text = '\n' + lambs.step(parsed);
        var op = @"{"identifier: id, range: range, text: text, forceMoveMarkers: true@"}";
        editor.pushUndoStop();
        editor.executeEdits("lambs", [op]);
        editor.pushUndoStop();
        editor.revealPosition(editor.getPosition());
    });
 })))

    (sld #:title "html+css"
         `("I use racket for this but it basically amounts to"
           (pre () ,@@list{
 <html>
 ...
 <body>
   ...
   <p>blah blah hello goodbye</p>
   <div class="lambs">
     (λx.λy.y x) foo bar
   </div>
   <p>blah blah blah</p>
   <div class="lambs">
     (λx.λy.y x) foo bar
   </div>
   ...
 })))

    (sld #:title "part conclusion is okay yes"
         `(,(lnk "http://llama-the-ultimate.org/lists/lambs.html")))
    
    (sld #:title "appendix A is like, misc")

    (hai "a new version of"
         "purescript broke some of my stuff"
         "but only one time")

    (sld #:title "typeclasses, show and ord and such"
         `((pre () ,@@list{
 PSCi, version 0.11.7
 Type :? for help
 
 import Prelude
 > { x: 1 }
 })))
    (sld #:title "typeclasses, show and ord and such"
         `((pre () ,@@list{
 PSCi, version 0.11.7
 Type :? for help
 
 import Prelude
 > { x: 1 }
 Error found:
 in module $PSCI
 at <internal> line 0, column 0 - line 0, column 0

    No type class instance was found for

      Data.Show.Show { x :: Int
                     }


  while applying a function eval
    of type Eval t2 => t2
                       -> Eff
                            ( console :: CONSOLE
                            )
                            Unit
    to argument it
  while checking that expression eval it
    has type Eff t0 t1
  in value declaration $main

  where t0 is an unknown type
        t1 is an unknown type
        t2 is an unknown type

  See https://github.com/purescript/documentation/blob/master/errors/NoInstanceFound.md for more information,
  or to contribute content related to this error.
 })))

    (hai "imported module"
         "has thing of type T in it"
         "don’t know where T is")

    (sld #:title "record punning"
         "if you have e.g."
         '((pre () "x = \"hello\""))
         "and you wanna do"
         '((pre () "{ x: x, y: 5 }"))
         "you can do"
         '((pre () "{ x, y: 5 }"))
         "instead."
         "(I think that’s weird)")
    
    (hai "does not have tuples"
         "oogly boogly beep boop bap"
         "currying instead")
    
    (imgsld "imgs/atom-error1.png")
    (sld `((pre () ,@@list{
 Could not match type

   Ren -> Exec

 with type

   Exec


 while checking that type Ren -> Exec
   is at least as general as type Exec
 while checking that expression renameHalp f
   has type Exec
 in value declaration stepExec
 })))

    paren
    (imgsld "imgs/atom-error2.png")
    (sld `((pre () ,@@list{
 Could not match type
 
   Function
   
 with type
 
   ParserT a0

   
 while trying to match type Function (ParserT t3 t4 t5)
   with type ParserT a0 m1
 while checking that expression (between (string "(")) (string ")")
   has type ParserT a0 m1 b2
 in value declaration paren

 where m1 is a rigid type variable
       b2 is a rigid type variable
       a0 is a rigid type variable
       t5 is an unknown type
       t3 is an unknown type
       t4 is an unknown type
 })))
    
    (sld #:title "okay bye")
    beginning/end))

(write-html-file
 "index.html"
 (->html-xexpr
  "some slides"
  (make-slides all-slides)))

#lang at-exp racket
(require "structs.rkt")

(provide notes
         test-note)

(define notes
  (list

   (nt 'exceptions
       "Exceptions are for exceptions"
       @p{
 If you have like an A -> B, then you can usually count on getting a B back if
 you pass in an A. In this or that language, there may be exceptions to this.
 For example, an exception would be an exception.
}
       )
   
   (nt 'ltuo
       "Llama the ultimate object"
       @p{
 It does extend animal.
 })
   
   )


  
  )

(define test-note
  (nt 'test
      "Test"
      @p{
 Meep meep meep.
 }
      @p{
 Meep meep meep.
 }
      (ol
       @li{Meep meep}
       @li{Moop moop}
       @li{Maap maap})
      
      (ul
       @li{Meep meep}
       @li{Moop moop}
       @li{Maap maap})
))
#lang at-exp racket
(provide LISP-forty-two-note)
(require "structs.rkt")

(define LISP-forty-two-note
  (nt 'LISP-forty-two
      "Solving a number problem using idiomatic LISP"
      (date 2017 03 26)
      @p{
 Hi okay one time I ran into a number problem that went something like this:
 @q{How many (natural) numbers less than or equal to one million are there whose digits add up to forty-two?}
}
      @p{
 Okay let’s solve this using Racket. Racket is a maybe a LISP.
 In LISP, pretty much the only thing that matters is you have to use parentheses.
}
      (blockquote
       (quot @p{Parentheses essentially are the basis of computation.})
       @cite{―Robert Constable, 8 minutes or so into @lnk["https://www.youtube.com/watch?v=OubXOd0Twl4"]{this OPLSS 2015 lecture}})
      @p{
 Anyway we can stare at this problem for a while and maybe notice three things.
 One thing is that the digits in one million do not add up to forty-two.
 Another thing is that the numbers less than one million all have six digits (or they might as well have, and can be padded with leading zeroes).
 Anothother thing is that forty-two divided by six equals seven.
}
   @p{
 So. We only need to care about numbers that have six digits, and if every digit is seven they add up to forty-two.
 More, if the digits in a number are @q{balanced around seven} they also add up to forty-two. (A six can be made up for by an eight,
 a three by two nines, and so on.)
}
   @p{
 Okay so that’s extremely good to know. We pretty much just wanna balance stuff. And parentheses are like incredibly good things to balance.
}
   @brk
   @p{
 Racket comes with a @tt{read}-procedure.
 @tt{read} reads an expression from something, and it makes sure parentheses are balanced.
 Problem solved, then, more or less...
}
   @block{
#lang racket
}
      @p{
 We need some halp.
 @tt{read-string} will @tt{read} a string until its end.
 If any parentheses are out of balance, @tt{read} will throw and the @tt{with-handlers}-bit will catch and make it so that we return the number zero.
 Otherwise one.
}

      @block{
(define (read-string s)
  (with-handlers
      ([(λ (_) #t) (λ (_) 0)])
    (define in (open-input-string s))
    (let loop ()
      (unless (eof-object? (read in))
        (loop)))
    1))
}
   @p{
 Woop woop. We can use @tt{read-string} to kind of check if a string has balanced parentheses.
 If we can turn numbers into strings, so that a string only has balanced parentheses in it if the digits in the number add up to forty-two, then stuff.
 }
   @p{
 @tt{number->chars} will turn a number into a list of character, maybe padded with some zeroes:
}
   @block{
(define (number->chars n)
  (string->list (~a n
                    #:min-width 6
                    #:pad-string "0")))
}
   @p{
 Now we can have one character for every digit in a number. We make a @tt{char->string}-function that will turn a character like that into a string.
 The string will have parentheses that are just as much balanced as the digit was balanced around seven:
}
   @block{
(define (char->string c)
  (match c
    [#\0 "((((((("]
    [#\1 "(((((("]
    [#\2 "((((("]
    [#\3 "(((("]
    [#\4 "((("]
    [#\5 "(("]
    [#\6 "("]
    [#\8 ")"]
    [#\9 "))"]
    [_ "horses"]))
}
   @p{
 So, in order to turn a number into a good string, we use @tt{number->chars}, then @tt{char->string} each digit-character. And then adjust as necessary:
 We will sort the characters in the string so that any left parentheses come before any right parentheses.
 @tt{number->string} does:
}
   @block{
(define (number->string n)
  (define char-list
    (map char->string (number->chars n)))

  (list->string
   (sort (append* (map string->list char-list))
         char<?)))
}
   @p{
 Now all that remains is to pick the numbers we care about,
 then feed to @tt{read-string} the strings we get by applying @tt{number->string}.
 @tt{read-string} should return one if things are balanced and zero if not, so if we add together all those zeroes and ones we’re good.
}
   @block{
(for/sum ([n (in-range 1000000)])
  (read-string (number->string n)))
}
   @p{
 You can get the full program at @lnk["https://gist.github.com/Glorp/e615a9b51dc74d8f93a30434c009d06d"]{blah}. Put it into your DrRacket, press F5 or so, and voi—some 20 seconds wait—là, you will have an answer.
}
   ))

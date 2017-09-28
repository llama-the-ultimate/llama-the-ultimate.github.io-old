#lang at-exp racket
(require "structs.rkt")

(provide foldr-note)

(define foldr-note
  (nt 'foldr
      "Something, foldr, sugar"
      (date 2017 8 4)
      @p{
 I dunno. Does taking away some sugar and infixity make some things more clear?
}
      @p{
 Some Standard ML:
}
      @block{
 - nonfix +;
 nonfix +
 - + (1, 2);
 val it = 3 : int
 - nonfix ::;
 nonfix ::
 - :: (1, :: (2, :: (3, nil)));
 val it = [1,2,3] : int list
 - foldr + 0 (:: (1, :: (2, :: (3, nil))));
 val it = 6 : int
}
      @p{
 (We removed the infix thing from @tt{+} and @tt{::} (the plus function and the list @q{cons}).
 They take tupled arguments. Infix @ttc{1 + 2} is nonfix @ttc{+ (1, 2)}, and so on.)
}
      @p{
 Here, I guess we can say that
 @ttl{foldr + 0 (:: (1, :: (2, :: (3, nil))))}
 is like equivalent to
 @ttl[#:stop? #t]{+ (1, + (2, + (3, 0)))}.
}
      @p{
 And it is maybe more clear how
 @ttl{+ (1, + (2, + (3, 0)))}
 is similar to the list
 @ttl[#:stop? #t]{0 (:: (1, :: (2, :: (3, nil)))}?
}
      @p{
 (It is like list we started with, but with the list constructors,
 @tt{::} and @tt{nil},
 replaced with @tt{+} and @tt{0}
 (the first two values we gave to @tt{foldr})).
}
      
      @p{
 Also maybe unsurprising that
 @ttl{foldr :: nil (:: (1, :: (2, :: (3, nil))))}
 will be equivalent to
 @ttl{:: (1, :: (2, :: (3, nil)))}
 and evaluate to a list rather the same as the one we started with?
}
      @brk
      @p{
 (Like, more clear compared to something like saying that
 @ttl{foldr (op +) 0 [1, 2, 3]}
 is equivalent to
 @ttl[#:stop? #t]{1 + (2 + (3 + 0))}?)
}
      @brk      
      @p{
 And also like maybe not I dunno.
}
      ))



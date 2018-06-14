#lang at-exp racket
(provide some-books-note)
(require "structs.rkt")

(define dispossessed
  (nt 'dispossessed
      "The Dispossessed"
      (date 2018 6 14)
      (blockquote
       (quot @p{
 In a human sacrifice to deity there might be at least a mistaken and terrible beauty;
 in the rites of the moneychangers, where greed, laziness, and envy were assumed to move all men’s acts,
 even the terrible became banal.
 })
       #f)
      @p{
 Ursula K. Le Guin.
}))

(define left-hand
  (nt 'left-hand
      "The Left Hand of Darkness"
      (date 2018 6 14)
      @p{
 Ursula K. Le Guin. This one is a book too.
 }))

(define moby-dick
  (nt 'moby-dick
      "Moby-Dick"
      (date 2018 6 14)
      (blockquote
       (quot @p{Call me Moby-Dick.})
       #f)
      @p{
 Herman Melville. Nice @lnk["https://www.youtube.com/watch?v=v-Su1YXQYek"]{soundtrack}.
 }))

(define slaughterhouse-5
  (nt 'slaughterhouse-5
      "Slaughterhouse-Five"
      (date 2018 6 14)
      @p{
 Kurt Vonnegut. A book.
 }))

(define cats-cradle
  (nt 'cats-cradle
      "Cat’s Cradle"
      (date 2018 6 14)
      (blockquote
       (quot @p{“Ah, God,” says Bokonon, “what an ugly city every city is!”})
       #f)
      @p{
 Kurt Vonnegut.
 }))

(define ubik
  (nt 'ubik
      "Ubik"
      (date 2018 6 14)
      @p{
 I was like, did I highlight anything in this one? Oh:
}
      (blockquote
       (quot @p{‘Cream or sugar?’ the speaker of the shop’s ruling monad turret asked.})
       #f)
      @p{
 So you know if you’re into Haskell or whatever then...
}
      @p{
 Philip K. Dick. Oh and like, not from or even directly about the book,
 but I like these bits from @lnk["http://2010philipkdickfans.philipkdickfans.com/frank/vertexin.htm"]{an interview}:
}
      (blockquote
       (quot @p{
 All the parts of that book did not add up; all the ingredients did not make a coherency. Now some people are put off by that.
 })
       #f)
      (blockquote
       (quot @p{
 The basic thing is, how frightened are you of chaos? And how happy are you with order?
 })
       #f)))

(define seeing
  (nt 'seeing-like-a-state
      "Seeing Like a State"
      (date 2018 6 14)
      (blockquote
       (quot @p{
 The detailed reasons for the failure are of less interest for our purposes
 than the fact that most of them could be summarized under the rubric of @em{context}.})
       #f)
      @p{
 James C. Scott. I read this book because @lnk["https://twitter.com/marick"]{Brian Marick} sometimes recommends this book?
}
      @p{
 A @q{big rewrite} of like a city or a forest is also bad. Not only Software Engineering is horrible.
 }))

(define against-method
  (nt 'against-method
      "Against Method"
      (date 2018 6 14)
      (blockquote
       (quot @p{
 theoretical anarchism is more humanitarian and more likely to encourage progress than its law-and-order alternatives
 })
       #f)
      @p{
 Paul Feyerabend. Mlep.
 }))

(define odyssey
  (nt 'the-odyssey
      "The Odyssey"
      (date 2018 6 14)
      (blockquote
       (quot @p{That bad idea took hold of them; they did it.})
       #f)
      @p{
 The @lnk["https://twitter.com/EmilyRCWilson"]{Emily Wilson} translation.
}
      @p{
 I think I started reading some other translation one time.
 And then I stopped reading it before I had read very much of it.
 This one I read all of, which maybe suggests that I like this one more better.
 }))

(define some-books-note
  (nt 'some-books
      "Some books"
      #f
      @p{
 Okay, not reviews or anything.
 Maybe a quote or two, maybe a note about @em{something},
 but mostly just like, these are some books.
 I don’t think I disliked reading them.
}
      @p{
 (The dates under the titles are just when that bit was added to this page.
 Like they don’t have much to do with when the books were written or read or anything.)
}
      seeing
      odyssey
      against-method
      ubik
      dispossessed
      left-hand
      moby-dick
      slaughterhouse-5
      cats-cradle      
      ))
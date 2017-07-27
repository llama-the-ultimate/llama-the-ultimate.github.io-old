#lang at-exp racket
(provide lambs-list)
(require "../structs.rkt"
         "what.rkt"
         "how.rkt"
         "nums.rkt"
         "bools.rkt")

(define lambs-list
  (note-list
   (nt
    'lambs
    "Some lambda-notes"
    #f
    @p{
 Bla blah.
 This is a collection of notes with lambda calculus stuff.
 The posts tend to come with a kind of live lambda calculus environment where we can run examples or like play around.
}
    @p{
 Couple of the posts are maybe more introductiony than others.
 @nlnk['lamb-how]{How} is for how to editor, keys that can be pressed such.
 @nlnk['lamb-what]{What} is for syntax and semantics of the lambda calculus we’re using.
}
    @p{
 Also there’s kind of a lambda playground @ilnk["/lambdas.html"]{over here}.
 Works the same as the editors embedded in the different posts.
 It’s better for things like just playing around, since it doesn’t come like, surrounded in more blogposty stuffs.
}
    )
   
   (list lamb-nums-note
         lamb-how-note
         lamb-what-note
         lamb-bools-note)))
#lang at-exp racket
(require "structs.rkt")

(provide js-cm-note)

(define js-cm-note
  (nt 'js-cm
      "Lambdas, JavaScript"
      (date 2018 12 16)
      @p{
 Blah blah blah.
 And so I replaced the PureScript code and the Monaco editor used for @ilnk["/lists/lambs.html"]{the lambda things} with some JavaScript and CodeMirror.
 Something to do with liking smol things, hundreds being smoller than thousands, and so on.
}
      @p{
 Anyway there once was like @lnk["http://www.lambdadays.org/lambdadays2018/jonas-winje"]{a Lambda Days talk} about the PureScript-and-Monaco version of the stuff.
 So things like @lnk["http://llama-the-ultimate.org/slides/lambdadays2018/"]{these slides} are in some sense vaguely out of date.
}

      @p{
 Like, that is, links to code and such should work. Links in the direction of lambda editors that run in the browser now lead to JavaScript-and-CodeMirror version.
 Which mostly doesn’t like matter, since they work pretty much the same.
 The latest PureScript-and-Monaco version of the stuff is tagged as
 @lnk["https://github.com/llama-the-ultimate/llama-the-ultimate.github.io/tree/monaco-and-ps"]{monaco-and-ps}.
 It can be checked out or downloaded and should like run just fine from local filesystem.
}
      @p{
 (The code currently in use is mostly the stuff in this @lnk["https://glitch.com/~lambs"]{Glitch project}.
 Is JavaScript so I don’t know what I’m doing etc.
 But like Glitch is nice.)
}
      ))



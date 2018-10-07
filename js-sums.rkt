#lang at-exp racket
(require "structs.rkt")

(provide js-sums-note)

(define js-sums-note
  (nt 'js-sums
      "A little JavaScript, a few sums"
      (date 2018 10 7)
      
      @p{
 (Standard ML code @lnk["https://gist.github.com/Glorp/4c7917ad351e1340b07b1cdeb827d62c"]{here}.
 JavaScript code @lnk["https://gist.github.com/Glorp/fc614dae2d91b79c4c7d4c96785da558"]{here}.)
}

      @p{In chapter 6 of @lnk["https://mitpress.mit.edu/books/little-mler"]{The Little MLer} there is some stuff.}
      
      @p{There is @tt{fruit}:}
      @block{
 datatype fruit =
     Peach
   | Apple
   | Pear
   | Lemon
   | Fig
}
      
      @p{There is @tt{tree}:}
      @block{
 datatype tree =
     Bud
   | Flat of fruit * tree
   | Split of tree * tree
}
      @p{There is @tt{height}, which looks @em{quite} like this in the book:}
      @block{
 (* height : tree -> int *)
 fun height Bud = 0
   | height (Flat(_,  t)) = 1 + height (t)
   | height (Split(s, t)) = 1 + Int.max (height(s), height(t))
}
      @p{
 There are other things in there too. More functions, and like, stuff. We mostly want these, just.
}
      @p{Anyway we can make a couple of trees:}
      @block{
 val smol_tree = Split (Bud, Flat (Peach, Bud))
 val larger_tree = Split (Flat (Apple, Flat (Lemon, Bud)), Flat (Peach, Bud))
}
      @p{And so, in like a REPL:}
      @block{
 - height smol_tree;
 val it = 2 : int
}
      @block{
 - height larger_tree;
 val it = 3 : int
}
      @p{Okay.}

      @brk
      
      @p{So JavaScript is a pretty nonstandard ML.}
      @p{
 (By the way, from here on, I don’t know what I’m doing, how stupid it is, how weird it is, or anything.
 I really don’t know JavaScript, or like how people use it, much.)}
      @p{
 In the book we use sums for the tree-stuff.
 Sums are also sometimes called tagged unions.
 We will make a @tt{tag}-function for tagging like, some @em{stuff}:
}
      @block{
 const tag = t => @"{"
   function halp() @"{"
     return @"{" tag: t, values: [... arguments] @"}"
   @"}"
   return halp;
 @"}";
}
      @p{
 We can try to use it. Something like this:
}
      @block{
 tag("label")(1, "horse", [2,3]);
}
      @p{Gives us something like this:}
      @block{
 @"{"
   tag: "label",
   values: Array(3)
     0: 1
     1: "horse"
     2: (2) [2, 3]
 @"}"
}
      @p{It appears to have the tag and the stuff we passed in. Good. We can make constructors then.}
      @p{Fruit:}
      @block{
 const Peach = tag("Peach")();
 const Apple = tag("Apple")();
 const Pear = tag("Pear")();
 const Lemon = tag("Lemon")();
 const Fig = tag("Fig")();
}
      @p{Tree:}
      @block{
 const Bud = tag("Bud")();
 const Flat = tag("Flat");
 const Split = tag("Split");
}
      @p{
 (@tt{Flat} and @tt{Split} are like constructor-functions that need additional stuff when we use them to construct stuff.
 The other ones are constructors that don’t need additional stuff, so we have like already, uh, passed in the no arguments to those.)
}
      @p{Now we can make the trees:}
      @block{
 const smol_tree = Split(Bud, Flat(Peach, Bud));
 const larger_tree = Split(Flat(Apple, Flat(Lemon, Bud)), Flat(Peach, Bud));
}      
      @p{So we have like half of sum now. We have construct. We need destruct.}
      @p{
 Okay with sums it’s like, in order to construct a value you have to do @em{one of the things}.
 A fruit is a peach @em{or} an apple @em{or} one of the other ones.
 In order to construct one we only have to choose like which one.
}
      @p{
 But in order to destruct a value, it’s like, it can be any one of the things, so we have to know what to do in every case.
 We have to know what to do if it is a peach @em{and} we have to know what to do if it is an apple @em{and} so on.
 We have to know how to deal with @em{all the things}.
}
      @p{
 A thing some people enjoy saying is that sum is the dual of product.
 In order to construct a product you have to supply @em{all the things},
 but when destructing one you’re maybe only interested in @em{one of the things}, and you can like get at that thing while ignoring the other things.
 (E.g. to make a pair you have to supply two things, but when you have a pair you can use just the first of its things if you like.)
}
      @p{
 So a constructed product could totally have everything required to destruct a sum. Like maybe an object along the lines of:
}
      @block{
 @"{"
   Peach: // what to do if it is a peach
   Apple: // what to do if it is an apple
   // and so on...
 @"}"
}

      @p{
  So if we have a sum-value and like a, uh, corresponding product-value,
  then we can use the tag from the sum-thing to look up the @q{what to do} in the product-thing.
  We will use functions for the @q{what to do.} We will make a @tt{match}-function for destructing sums:
}
      @block{
  const match = cases => x => cases[x.tag].apply(null, x.values);
}
      @p{We can try to make a function with match:}
      @block{
 const is_apple =
   match(
     @"{"
       Peach: () => false,
       Apple: () => true,
       Pear: () => false,
       Lemon: () => false,
       Fig: () => false
     @"}"
   );
}
      @p{And then use it:}
      @block{is_apple(Apple);}
      @block{is_apple(Fig);}
      @p{That gives us like @tt{true} and @tt{false}. Seems fine.}
 
      @p{Okay should can make @tt{height} then:}
      @block{
 const height =
   match(
     @"{"
       Bud: () => 0,
       Flat: (_, t) => 1 + height(t),
       Split: (a, b) => 1 + Math.max(height(a), height(b))
     @"}"
   );
}
 
      @p{Test:}
      @block{height(smol_tree);}
      @block{height(larger_tree);}
      @p{And that gives like @tt{2} and @tt{3}. So probably yay.}
      ))
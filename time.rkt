#lang at-exp racket
(provide time-note)
(require "structs.rkt")

(define time-note
  (nt 'time
      "Sculpting in java.time"
      (date 2018 01 21)

      @block{
 public final class Instant
 extends Object
 implements Temporal, TemporalAdjuster, Comparable<Instant>, Serializable
}

      @p{
 This class models a single instantaneous point on the time-line. 
 Time is one and undivided.
}
      @p{
 If you throw even a cursory glance into the past, at the life which
 lies behind you, not even recalling its most vivid moments, you are
 struck every time by the singularity of the events in which you took
 part, the unique individuality of the characters whom you met.
 This singularity is like the dominant note of every moment of existence; in
 each moment of life, the life principle itself is unique.
 To achieve this, the class stores a @tt{long} representing epoch-seconds and an @tt{int} representing nanosecond-of-second,
 which will always be between 0 and 999,999,999.
}
      @p{
 Life, constantly moving and changing,
 allows everyone to interpret and feel each separate moment in his own way;
 use of identity-sensitive operations (including reference equality (@tt{==}),
 identity hash code, or synchronization) on instances of @tt{Instant} may have unpredictable results and should be avoided. 
}
      
      @brk

      
      @block{
 public final class Duration
 extends Object
 implements TemporalAmount, Comparable<Duration>, Serializable
}
      @p{A time-based amount of time, such as '34.5 seconds'.}
      @p{
 This class models a quantity or amount of time in terms of seconds and nanoseconds.
 
 But I am not thinking of linear time,
 meaning the possibility of getting something done, performing some action.
 The action is a result,
 and what I am considering is the cause
 which makes man incarnate in a moral sense.
}
      @p{
 A physical duration could be of infinite length.
 The model is of a directed duration, meaning that the duration may be negative.
 It is not possible to catch the moment at which the positive goes
 over into its opposite, or when the negative starts moving towards the
 positive. Infinity is germane, inherent in the very structure.
}
      @brk
      
      @block{
 public abstract class Clock
 extends Object
}
      @p{A clock providing access to the current instant, date and time using a time-zone.}
      @p{
 In a certain sense the past is far more real, or at any rate more stable, more
 resilient than the present. The present slips and vanishes like sand
 between the fingers, acquiring material weight only in its recollection.
}
      @p{Best practice for applications is to pass a @tt{Clock} into any method that requires the current instant.}
      
      @brk

      @block{
 public class DateTimeException
 extends RuntimeException
}
      @p{
 Time can vanish without trace in our
 material world for it is a subjective, spiritual category.
 This exception is used to indicate problems with creating, querying and manipulating date-time objects.
}
      
      ))

#lang racket
(provide save-svg-file)

(require (only-in 2htdp/image square image-width image-height)
         (only-in mrlib/image-core render-image)
         (only-in racket/draw svg-dc%)
         (only-in xml write-xexpr string->xexpr))

(define (write-svg-image image
                         port
                         [width (image-width image)] 
                         [height (image-height image)])
  (define sdc (new svg-dc% [width width] [height height] [output port]))
  (send sdc start-doc "")
  (send sdc start-page)
  (send sdc set-smoothing 'aligned)
  (render-image image sdc 0 0)
  (send sdc end-page)
  (send sdc end-doc))

(define (re-id svg-xml new-id)
  (match svg-xml
    {`(svg ,attributes
           "\n"
           (g ((id ,_)) . ,group-content)
           "\n"
           .
           ,rest)
     `(svg ,attributes
           "\n"
           (g ((id ,new-id)) . ,group-content)
           "\n"
           .
           ,rest)}
    {`(svg ,attributes
           "\n"
           (defs . ,defsrest)
           "\n"
           (g ((id ,_)) . ,group-content)
           "\n"
           .
           ,rest)
     `(svg ,attributes
           "\n"
           (defs . ,defsrest)
           "\n"
           (g ((id ,new-id)) . ,group-content)
           "\n"
           .
           ,rest)}))
     
(define (save-svg-file img group-name filename)
  (define o (open-output-string))
  (write-svg-image img o)
  (define bad-x (string->xexpr (get-output-string o)))
  (define good-x (re-id bad-x group-name))
  (call-with-output-file filename
    (λ (port)
      (display (format "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n") port)
      (write-xexpr good-x port))
    #:exists 'truncate))

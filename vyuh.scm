(define (imgs) (vector->list (cadr (gimp-image-list))))
(define (resize img)
    (gimp-image-resize
      img
      (car (gimp-image-width img))
      (* (car (gimp-image-get-layers img)) (car (gimp-image-height img)))
      0
      0))
(define (process img) 
  (let*
    (
     (i (info img))
     (h (caddr i)))
    (shift-layers (cadddr i) h)
    (resize img)
    (gimp-image-flatten img)))
(define (info img)
  (list
    img
    (car (gimp-image-width img))
    ( car (gimp-image-height img))
    (vector->list (cadr (gimp-image-get-layers img)))))
(define (shift-layers layers height)
  (if (> (length layers) 1)
    (begin
      (map (lambda (layer) (gimp-layer-translate layer 0 height)) (cdr layers))
      (shift-layers (cdr layers) height))))
(define (script-fu-concat-layers img)
  (gimp-image-undo-group-start img)
  (gimp-context-push)
  (process img)
  (gimp-context-pop)
  (gimp-image-undo-group-end img)
  (gimp-displays-flush))

(script-fu-register
  "script-fu-concat-layers"
  "Concatenate Layers Vertically"
  "Concatenates Layers Vertically. For example if each layer is one page of a PDF."
  "Prashant Karmakar"
  "Copyright 2019, Prashant Karmakar"
  "Saturday 15 June 2019 12:28:55 PM IST"
  "*"
  SF-IMAGE "The Image to Work on" 0)
(script-fu-menu-register "script-fu-concat-layers" "<Image>/Tools/Transform Tools")

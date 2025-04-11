(module common (inc! add-to-list!)
  (import scheme (chicken base))

  (define-syntax inc!
    (syntax-rules ()
      [(inc! x y)
       (set! x (+ x y))]
      [(inc! x)
       (inc! x 1)]))

  (define-syntax add-to-list!
    (syntax-rules ()
      [(add-to-list! lst itm)
       (set! lst (cons itm lst))])))

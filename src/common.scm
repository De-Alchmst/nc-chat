(module common (inc! add-to-list! in?)
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
       (set! lst (cons itm lst))]))


  (define (in? itm lst)
    (cond
      ((null? lst)
       #f)

      ((equal? (car lst) itm)
       (car lst))

      (else
       (in? itm (cdr lst))))))

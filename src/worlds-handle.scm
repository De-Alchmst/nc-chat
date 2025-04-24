(module worlds-handle (motd default-world default-place list-worlds)
  (import scheme (chicken base)
          load-worlds)

  (define default-world (car worlds))


  (define (default-place #!optional (world default-world))
    (car (world-places world)))


  (define (list-worlds)
    (for-each print-world worlds))



  ;; passing world as both symbol and tree can be useful, so this makes it easy
  (define (world->tree world)
    (if (symbol? world)
      (symbol->value world)
      world))


  (define (find-item itm lst)
    (cond
      ((null? lst)
       '())

      ((and
         (list? (car lst))
         (not (null? (car lst)))
         (equal? (caar lst) itm))
       (cdar lst))

      (else
        (find-item itm (cdr lst)))))


  ;; for easier treversal
  (define-syntax at-tree-path
    (syntax-rules ()
      [(at-tree-path tree sym)
       (find-item sym tree)]

      [(at-tree-path tree syms ... sym)
       (find-item sym (at-tree-path tree syms ...))]))


  (define-syntax at-world-path
    (syntax-rules ()
      [(at-world-path world syms ...)
       (at-tree-path (world->tree world) syms ...)]))


  (define (print-world world)
    (print " | " world " | - " (world-description world)))


  (define (world-description world)
    (let ((desc (at-world-path world 'description)))
      (cond
        ((null? desc)
         "[NO DESCRIPTION PROVIDED]")
        
        ((procedure? (car desc))
         ((car desc)))

        (else
         (car desc)))))

   
  (define (world-places world)
    (at-world-path world 'places)))

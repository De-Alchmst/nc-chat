(module worlds-handle (get-motd default-world default-place
                            list-worlds look-around
                            goto-pathway)
  (import scheme (chicken base)
          load-worlds)

  (define default-world (car worlds))


  (define (get-motd)
    (val->string motd))


  (define (default-place #!optional (world default-world))
    (car (world-places world)))


  (define (list-worlds)
    (for-each print-world worlds))


  (define (look-around place)
    ;; at-tree-path does not work here and neither I nor Claude have any
    ;; idea why. Let's hope it doesn't break any further...
    (let ((welcome       (find-item 'welcome place))
          (interactives  (find-item 'interactives place))
          (pathways      (find-item 'pathways place)))

      (if (not (null? welcome))
        (print (val->string welcome)))

      (cond ((not (null? interactives))
             (print "\n--- interactives ---")
             (for-each print-interactive interactives)))

      ;; I guess you can just have one room?
      (cond ((not (null? pathways))
             (print "\n--- pathways ---")
             (for-each print-pathway pathways)))

      (print)))


  (define (goto-pathway new-key current-place world)
    (let ((new-place-entry (find-item new-key
                                      (find-item 'pathways current-place))))
      (if (null? new-place-entry)
        '()
        (world-place world (cadr new-place-entry)))))





  ;; passing world as both symbol and tree can be useful, so this makes it easy
  (define (world->tree world)
    (if (symbol? world)
      (symbol->value world)
      world))


  ;; with the key
  (define (find-item* itm lst)
    (cond
      ((null? lst)
       '())

      ((and
         (list? (car lst))
         (not (null? (car lst)))
         (equal? (caar lst) itm))
       (car lst))

      (else
       (find-item* itm (cdr lst)))))


  ;; without the key
  (define (find-item itm lst)
    (let ((out (find-item* itm lst)))
      (if (null? out)
        '()
        (cdr out))))


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


  ;; to convert description value in variety of forms into a string
  (define (val->string val)
    (cond
      ((null? val)       "")
      ((list? val)       (val->string (car val)))
      ((procedure? val)  (val))
      ((symbol? val)     (symbol->string val))
      (else              val)))
        
   
  (define (world-places world)
    (at-world-path world 'places))


  (define (world-place world place-sym)
    (find-item* place-sym (world-places world)))


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


  (define (print-interactive int)
    (print " | " (car int) " | - " (val->string (cadr int))))

  ;; they actually do the same thing...
  (define (print-pathway pat)
    (print-interactive pat)))

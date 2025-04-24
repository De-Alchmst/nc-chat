(module handle-worlds (motd default-world default-place)
  (import scheme (chicken base)
          load-worlds)

  (define default-world (car worlds))
  (define default-place '())


  (define (find-item itm lst)
    (cond
      ;; atom? so that I don't need to make fuether checks
      ((or (null? lst) (atom? lst))
       '())

      ((equal? (car lst) itm)
       (cdr lst))

      ;; if value is '(), it will search the entire tree anyways
      ;; but it should return '() in the end, so it works
      (else
       (let ((val (find-item itm (car lst))))
         (if (null? (cdr lst))
           val
           (if (null? val)
             (find-item itm (cdr lst))
             val))))))

   
  (define (world->places world)
    (find-item 'places
               (if (symbol? world)
                 (symbol->value world)
                 world)))

  (print (find-item 'clock (find-item 'base (world->places 'hub)))))

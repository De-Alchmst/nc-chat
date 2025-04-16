(module command-handle (handle-command)
  (import scheme (chicken base)
          srfi-13
          render user)

  (define help "\x1b[32m
== HELP ==
silent commands:
  /help
  /set-name <new-username>
  /set-color <color>
  
loud commands:
  !exit
\x1b[29m")

  (define-syntax red
    (syntax-rules ()
      [(red str ...)
       (string-append "\x1b[31m" str ... "\x1b[39m")]))
       



  (define (handle-command line user)
    (let ((line (string-trim-both line)))
      (cond
        ;; nothing in, nothing out...
        ((equal? line "")
         "")

        ;; silent commands
        ((eqv? (car (string->list line)) #\/)
         (handle-silent-commands line user))

        ;; loud commands
        ((eqv? (car (string->list line)) #\!)
         (handle-loud-commands line user))

        ;; just a message
        (else
         (string-append (get-username-string user) " | " line)))))
      

 

  (define (handle-silent-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words)))

      (cond
        ((equal? command "/help")
         (print help))

        ((equal? command "/set-name")
         (if (null? (cdr words))
           (print (red "wrong number of args"))
           (set-user-name! user (cadr words))))

        (else
         (print (red "invalid command: " (car words))))))

    "")


  (define (handle-loud-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words)))

      (cond
        ((equal? command "!exit")
         '())

        (else
         (print (red "invalid command: " (car words)))
         "")))))

        

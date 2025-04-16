(module command-handle (handle-command)
  (import scheme (chicken base)
          srfi-13
          render)

  (define (handle-command line user)
    (cond
      ;; silent commands
      ((eqv? (car (string->list line)) #\/)
       (handle-silent-commands line user))

      ;; loud commands
      ((eqv? (car (string->list line)) #\!)
       (handle-loud-commands line user))
      
      ;; just a message
      (else
       (string-append (get-username-string user) " | " line))))
 

  (define (handle-silent-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words)))

      (cond
        (else
          (print "\x1b[31minvalid command: " (car words) "\x1b[39m")
          ""))))


  (define (handle-loud-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words)))

      (cond
        ((equal? command "!quit")
         '())

        (else
          (print "\x1b[31minvalid command: " (car words) "\x1b[39m")
          "")))))

        

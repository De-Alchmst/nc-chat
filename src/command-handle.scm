(module command-handle (handle-command)
  (import scheme (chicken base))

  (define (handle-command line)
    (if (equal? line "quit")
      '()
      (string-append "Hi " line))))
 

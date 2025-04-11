(module command-handle (handle-command)
  (import scheme (chicken base))

  (define (handle-command line)
    (if (or (equal? line "quit") (equal? line #!eof))
      '()
      (string-append "Hi " line))))
 

(module command-handle (handle-command)
  (import scheme (chicken base)
          render)

  (define (handle-command line user)
    (if (or (equal? line "quit") (equal? line #!eof))
      '()
      (string-append (get-username-string user) " | " line))))
 

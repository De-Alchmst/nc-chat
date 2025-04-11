(module nc-connection (start-server)
  (import scheme (chicken base) (chicken tcp) (chicken io)
          tcp-server
          command-handle server-handle)


  (define (start-server port)
    (print "Starting server on port: " port)

    ((make-tcp-server
      (tcp-listen port)
      (lambda ()
        (print "--- WELCOME TO NC-CHAT ---")
        (client-handle (new-user (current-output-port))))
      #t)))


  (define (client-handle uid)
    (let ((response (handle-command (read-line))))
      ; end connection
      (cond ((null? response)
             (print "BYE!")
             (disconnect-user uid))
      ; continue connection
            (else
             (display "\x1b[1A")
             (broadcast response)
             (client-handle uid))))))
    

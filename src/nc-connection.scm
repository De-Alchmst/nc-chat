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
        (client-handle (new-user)))
      #t)))


  (define (client-handle user-id)
    (let ((response (handle-command (read-line))))
      ; end connection
      (cond ((null? response)
             (print "BYE!")
             (disconnect-user user-id))
      ; continue connection
            (else
             (print response)
             (client-handle user-id))))))
    

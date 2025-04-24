(module nc-connection (start-server)
  (import scheme (chicken base) (chicken tcp) (chicken io) (chicken condition)
          tcp-server render
          commands-handle server-handle user
          handle-worlds)

  (tcp-read-timeout #f)


  (define (start-server port)
    (print "Starting server on port: " port)

    ((make-tcp-server
      (tcp-listen port)
      (lambda ()
        (print "--- WELCOME TO NC-CHAT ---\n")
        (print motd)

        (let ((cur-user (new-user (current-output-port))))
          (handle-exceptions exn
            ;; first exception handeler
            (disconnect-user cur-user)
              

            (client-handle cur-user))))

      #t)))


  (define (client-handle cur-user)
    (let ((response (handle-command (read-line) cur-user)))
      ;; end connection
      (cond ((null? response)
             (print "BYE!")
             (disconnect-user cur-user))

      ;; empty message
            ((equal? response "")
             (client-handle cur-user))

      ;; message
            (else
             (display "\x1b[1A") ;; one line up to replace prompt
             (broadcast response)
             (client-handle cur-user))))))
    

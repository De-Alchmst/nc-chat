(module nc-connection (start-server)
  (import scheme (chicken base) (chicken tcp) (chicken io) (chicken condition)
          tcp-server render
          commands-handle server-handle user
          worlds-handle commands-handle)

  (tcp-read-timeout #f)


  (define (start-server port)
    (print "Starting server on port: " port)

    ((make-tcp-server
      (tcp-listen port)
      (lambda ()
        (print "--- WELCOME TO NC-CHAT ---\n")
        (print (get-motd))

        (let ((user (new-user (current-output-port))))
          (broadcast-world (user-joined-string user)
                           (user-world user)
                           #:exception user)
          (look-around+ (user-place user))

          (handle-exceptions exn
            ;; first exception handeler
            (disconnect-user user)
              

            (client-handle user))))

      #t)))


  (define (client-handle user)
    (let ((response (handle-command (read-line) user)))
      ;; end connection
      (cond ((null? response)
             (print "BYE!")
             (disconnect-user user))

      ;; empty message
            ((equal? response "")
             (client-handle user))

      ;; message
            (else
             (display "\x1b[1A") ;; one line up to replace prompt
             (broadcast-place response (user-place user))
             (client-handle user))))))
    

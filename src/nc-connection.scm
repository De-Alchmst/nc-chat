(module nc-connection (start-server)
  (import scheme (chicken base) (chicken tcp) (chicken io)
          tcp-server
          command-handle)


  (define (start-server port)
    ((make-tcp-server
      (tcp-listen port)
      client-handle)) #t)


  (define (client-handle)
    (let ((response (handle-command (read-line))))
      ; end connection
      (cond ((null? response)
             (print "BYE!"))
      ; continue connection
            (#t
             (print response)
             (client-handle))))))
    

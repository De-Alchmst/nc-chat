(module server-handle (new-user disconnect-user
                       send-text
                       broadcast-server broadcast-world broadcast-place
                       users-with-name)

  (import scheme (chicken base)
          srfi-1
          user render common)

  (define next-user-id 1)
  (define user-list '())


  ;; add user and return his id
  (define (new-user port)
    (let* ((uid next-user-id)
           (user (make-user-short uid port)))
      (inc! next-user-id)
      (add-to-list! user-list user)
      user))


  (define (disconnect-user user)
    (set! user-list (filter
                      (lambda (usr) (not (= (user-id user) (user-id usr))))
                      user-list))
    
    (broadcast-world (string-append info-exclemation "buser "
                                    (get-username-string user) " has left")
                     (user-world user)))


  (define (broadcast-server text)
    (broadcast text user-list))


  (define (broadcast-world text world)
    (broadcast text (filter (lambda (user) (eq? (user-world user) world))
                            user-list)))


  (define (broadcast-place text place)
    (broadcast text (filter (lambda (user) (eq? (user-place user) place))
                            user-list)))



  (define (broadcast text users)
    (for-each (lambda (user) (send-text text (user-port user)))
              users))


  (define (send-text text port)
    (display "\x1b[1G" port) ;; begining of line
    (display "\x1b[K" port) ;; clear line right of cursor
    (display text port)
    (newline port)
    ; (display "\x1b[999C" port) ;; end of line
    (flush-output))


  (define (users-with-name username)
    (filter (lambda (user) (equal? (user-name user) username))
            user-list)))

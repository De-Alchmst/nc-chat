(module server-handle (new-user disconnect-user
                       broadcast send-text)
  (import scheme (chicken base)
          srfi-1
          user common)

  (define next-user-id 1)
  (define user-list '())


  ;; add user and return his id
  (define (new-user port)
    (let* ((uid next-user-id)
           (user (make-user-short uid port)))
      (inc! next-user-id)
      (add-to-list! user-list user)
      uid))


  (define (disconnect-user uid)
    (set! user-list (filter
                      (lambda (usr) (= uid (user-id usr)))
                      user-list)))


  (define (broadcast text)
    (for-each (lambda (user) (send-text text (user-port user)))
              user-list))


  (define (send-text text port)
    (display "\x1b[1G" port) ;; begining of line
    (display text port)
    (newline port)
    ; (display "\x1b[999C" port) ;; end of line
    (flush-output)))

(module server-handle (new-user disconnect-user
                       broadcast send-text
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


  (define (disconnect-user cur-user)
    (set! user-list (filter
                      (lambda (usr) (not (= (user-id cur-user) (user-id usr))))
                      user-list))
    
    (broadcast (string-append info-exclemation "buser "
                              (get-username-string cur-user) " has left")))



  (define (broadcast text)
    (for-each (lambda (user) (send-text text (user-port user)))
              user-list))


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

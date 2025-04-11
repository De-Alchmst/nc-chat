(module server-handle (new-user disconnect-user)
  (import scheme (chicken base)
          srfi-1
          user common)

  (define next-user-id 1)

  (define user-list '())

  ;; add user and return his id
  (define (new-user)
    (let* ((uid next-user-id)
           (user (make-user-short uid)))
      (inc! next-user-id)
      (add-to-list! user-list user)
      uid))


  (define (disconnect-user uid)
    (set! user-list (filter
                      (lambda (usr) (= uid (user-id usr)))
                      user-list))))

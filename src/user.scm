(module user (make-user make-user-short
               user-id user-port)
  (import scheme (chicken base)
          srfi-9)


  (define (make-user-short id port)
    (make-user id port))


  (define-record-type :user
    (make-user id port)
    :user?
    (id user-id)
    (port user-port)))

(module user (make-user make-user-short
               user-id)
  (import scheme (chicken base)
          srfi-9)

  (define (make-user-short id)
    (make-user id))

  (define-record-type :user
    (make-user id)
    :user?
    (id user-id)))

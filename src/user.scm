(module user (make-user make-user-short
               user-id user-port
               user-name set-user-name!
               user-color set-user-color!)
  (import scheme (chicken base)
          srfi-9)


  (define (make-user-short id port)
    (make-user id port "anon" 'green)) 


  (define-record-type :user
    (make-user id port name color)
    :user?
    (id user-id)
    (port user-port)
    (name user-name set-user-name!)
    (color user-color set-user-color!)))

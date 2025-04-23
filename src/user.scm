(module user (make-user make-user-short
              user?
              user-id user-port
              user-name set-user-name!
              user-color set-user-color!
              user-description set-user-description!)
  (import scheme (chicken base)
          srfi-9)


  (define (make-user-short id port)
    (make-user id port "anon" 'green "a user of nc-chat")) 


  (define-record-type <user>
    (make-user id port name color description)
    user?
    (id user-id)
    (port user-port)
    (name user-name set-user-name!)
    (color user-color set-user-color!)
    (description user-description set-user-description!)))

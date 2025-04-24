(module user (make-user make-user-short
              user?
              user-id user-port
              user-name set-user-name!
              user-color set-user-color!
              user-description set-user-description!
              user-world set-user-world!
              user-place set-user-place!)
  (import scheme (chicken base)
          srfi-9
          worlds-handle)


  (define (make-user-short id port)
    (make-user id port
               "anon" 'green "a user of nc-chat"
               default-world (default-place)))


  (define-record-type <user>
    (make-user id port name color description world place)
    user?
    (id user-id)
    (port user-port)
    (name user-name set-user-name!)
    (color user-color set-user-color!)
    (description user-description set-user-description!)
    (world user-world set-user-world!)
    (place user-place set-user-place!)))

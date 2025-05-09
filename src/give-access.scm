(module give-access (grant-world-access)
  (import scheme (chicken base)
   load-worlds server-handle user)

  (define (grant-world-access)
    (export-access
      (lambda (u txt #!key (exception #f))
        (broadcast-server txt #:exception (if exception u '())))

      (lambda (u txt #!key (exception #f))
        (broadcast-world txt (user-world u) #:exception (if exception u '())))

      (lambda (u txt #!key (exception #f))
        (broadcast-place txt (user-place u) #:exception (if exception u '())))


      user?
      user-name set-user-name!
      user-color set-user-color!
      user-description set-user-description!)))

          


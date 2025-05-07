(module give-access (grant-world-access)
  (import scheme (chicken base)
   load-worlds server-handle user)

  (define (grant-world-access)
    (export-access
      broadcast-server
      (lambda (u txt #!key (exception '()))
        (broadcast-world txt (user-world u) #:exception exception))
      (lambda (u txt) (broadcast-place txt (user-place u)))


      user?
      user-name set-user-name!
      user-color set-user-color!
      user-description set-user-description!)))

          


(module nc-chat ()
  (import scheme (chicken base)
          nc-connection)

  (start-server 9999))

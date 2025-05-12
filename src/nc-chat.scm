(module nc-chat ()
  (import scheme (chicken base)
          nc-connection load-worlds give-access)

  (grant-access)
  (start-server port))

(module nc-chat ()
  (import scheme (chicken base)
          nc-connection load-worlds give-access)

  (grant-world-access)
  (start-server port))

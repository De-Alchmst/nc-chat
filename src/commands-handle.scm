(module commands-handle (handle-command)
  (import scheme (chicken base)
          srfi-13
          render user server-handle worlds-handle)

  (define help "\x1b[32m
== HELP ==
silent commands:
  /help
  /list-colors
  /set-description <description>
  /describe <username>
  /look-around
  /list-worlds
  /list-users
  /list-users-world
  
loud commands:
  !exit
  !set-name <new-username>
  !set-color <color>
  !yell <text>
  !do <action>
  !goto <pathway>
  !runto <pathway>
  - !warp <world>

to interact witl object, prefix it with ':' like so ':item'
interactions might be silent or loud, it depends really

\x1b[0m")


  (define (handle-command line user)
    (let ((line (string-trim-both line)))
      (cond
        ;; nothing in, nothing out...
        ((equal? line "")
         "")

        ;; silent commands
        ((eqv? (car (string->list line)) #\/)
         (handle-silent-commands line user))

        ;; loud commands
        ((eqv? (car (string->list line)) #\!)
         (handle-loud-commands line user))

        ;; just a message
        (else
          (user-say-string user line)))))
 

  (define (handle-silent-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words))
           (rest (cdr words)))

      (cond
        ((equal? command "/help")
         (print help))

        ((equal? command "/list-colors")
         (print-colors))

        ((equal? command "/set-description")
         (if (null? rest)
           (print (red "you are supposed to write something here!"))
           (set-user-description! user
                                  (string-drop line
                                               (+ 1 ;; count in whitespace
                                                  (string-length command))))))

        ((equal? command "/describe")
         (if (null? rest)
           (print (red "wrong number of args"))
           (let* ((username (car rest))
                  (users (users-with-name username)))
             (if (null? users)
               (print (red username " is not with us right now"))
               (for-each (lambda (user)
                           (print (user-description user))
                           (print "\x1b[0m--------"))
                         users)))))


        ((equal? command "/list-worlds")
         (list-worlds))

        ((equal? command "/look-around")
         (look-around (user-place user)))

        ((equal? command "/list-users-world")
         (list-users))

        ((equal? command "/list-users")
         (list-users-place (user-place user)))

        (else
         (print (red "invalid command: " command)))))

    "")


  (define (handle-loud-commands line user)
    (let* ((words (string-tokenize line))
           (command (car words))
           (rest (cdr words)))

      (cond
        ((equal? command "!exit")
         '())

        ((equal? command "!set-name")
         (if (null? rest)
           (print (red "wrong number of args"))
           (let ((old-name (user-name user)))
             (set-user-name! user (car rest))
             (broadcast-world (user-name-change-string old-name user)
                              (user-world user)))))

        ((equal? command "!set-color")
         (if (null? rest)
           (print (red "wrong number of args"))
           (let ((color (string->symbol (car rest))))
             (if (valid-color? color)
               (let ((old-color (user-color user)))
                 (set-user-color! user color)
                 (broadcast-world (user-color-change-string old-color user)
                                  (user-world user)))
               (print (red (car rest) " is not a creative color!"))))))

        ((equal? command "!yell")
         (if (null? rest)
           (print (red "You cannot yell nothing..."))
           (broadcast-world (user-yell-string user
                              (string-drop line
                                           (+ 1 ;; count in whitespace
                                             (string-length command))))
                            (user-world user))))


        ((or
           (equal? command "!goto")
           (equal? command "!runto"))
         (if (null? rest)
           (print (red "wrong number of args"))

           (let* ((cur-place (user-place user))
                  (new-place (go-to-pathway (string->symbol (car rest))
                                           cur-place (user-world user))))
             (cond
               ((null? new-place)
                (print (red (car rest) " is not a valid pathway! I think...")))

               (else
                 (broadcast-place (user-moved-from-string user) new-place)
                 (set-user-place! user new-place)
                 (broadcast-place (user-moved-to-string user) cur-place)

                 (cond
                   ((equal? command "!goto")
                    (look-around new-place)
                    (print "\n--- users ---")
                    (list-users-place (user-place user)))))))))

        ((equal? command "!do")
         (if (null? rest)
           (print (red "you cannot do nothing"))
           (broadcast-place
             (do-string user (string-drop line (+ 1 ;; count in whitespace
                                                  (string-length command))))
             (user-place user))))

        ((equal? command "!warp")
         (if (null? rest)
           (print "warp where?")
           (let ((world (warp-to-world (string->symbol (car rest)))))
             (cond
               ((null? world)
                (print (red (car rest) " is not a valid world.")))
               (else
                (broadcast-world (user-left-string user)
                                 (user-world user))
                (set-user-world! user world)
                (broadcast-world (user-joined-string user)
                                 (user-world user)))))))
          

        (else
         (print (red "invalid command: " command))))
      "")))

        

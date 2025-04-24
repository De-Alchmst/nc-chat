(import (chicken time posix))

(define hub
  `((places
      (base
        (welcome "Welcome to the HUB!")
        (interactives
          (clock
            "An old clock hangs on the wall"
            `(lambda () (append-string
                          "it's X o'clock."
                          (seconds->string)))))
        (pathways
          ((gallery-door
             "This door leads to the gallery..."
             gallery))))

      (gallery
        (welcome "Welcome to the gallery!")
        (interactives
          ())
        (pathways
          ((base-door
             "This door leads to the main area."
             base)))))))
           
           

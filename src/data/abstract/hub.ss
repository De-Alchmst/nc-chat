(import (chicken time posix))

(define hub
  `((description "The main central area of this place")
    (places
      (base
        (welcome "Welcome to the HUB!")
        (interactives
          (clock
            "An old clock hangs on the wall"
            ,(lambda () (string-append
                          "it's "
                          (seconds->string)))))
        (pathways
          (gallery-door
            "This door leads to the gallery..."
            gallery)))

      (gallery
        (welcome "Welcome to the gallery!")
        (interactives
          ())
        (pathways
          (base-door
            "This door leads to the main area."
            base))))))
           
           

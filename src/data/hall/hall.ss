(import srfi-1)

(define hall
  `((description "A long hallway leading to places")
    (places
      (main
        (welcome "You feel like you have been there before...")
        (interactives
          (poster
            "An old poster of some old band. It feels old..."
            "You looked at it. You feel old.")

          (thing
            "<args> A simple thing. It speaks sometimes"
            ,(lambda (args user)
               (if (not (null? args))
                 (broadcast-world user
                                  (fold (lambda (a b)
                                          (string-append b " " a))
                                        "THE THING SAYS:" args)))
               "")))

        (pathways
          (forwards
            "Further into the hallway"
            main))))))
     

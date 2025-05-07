(define port 9999)

; (define worlds '(hub hall))
(define worlds '(hall hub))

(define (get-access brd-server brd-world brd-place
                    usr? usr-name set-usr-name!
                    usr-color set-usr-color!
                    usr-description set-usr-description!)

  (set! broadcast-world brd-world)
  (set! broadcast-server brd-server)
  (set! broadcast-place brd-place)

  (set! user? usr?)
  (set! user-name usr-name)
  (set! set-user-name! set-usr-name!)
  (set! set-user-color! set-usr-color!)
  (set! set-user-description! set-usr-description!))

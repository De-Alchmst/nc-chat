(module render (user-left-string user-moved-to-string user-moved-from-string
                user-name-change-string user-color-change-string
                user-say-string user-yell-string
                info-exclemation
                print-colors valid-color?
                in-color red green
                symbol->color-id)
  (import scheme (chicken base)
          srfi-1
          user) 

  (define info-exclemation "\x1b[31m!! \x1b[39m")


  (define colors '((red      "31")
                   (green    "32")
                   (yellow   "33")
                   (blue     "34")
                   (magenta  "35")
                   (cyan     "36")
                   (white    "37")

                   (bred     "91")
                   (bgreen   "92")
                   (byellow  "93")
                   (bblue    "94")
                   (bmagenta "95")
                   (bcyan    "96")
                   (bwhite   "97")))


  (define (symbol->color-id sym)
    (let ((item (filter (lambda (x) (eqv? sym (car x))) colors)))
      (if (null? item) "39" (cadar item))))


  (define-syntax in-color
    (syntax-rules ()
      [(in-color color str ...)
       (string-append "\x1b[" (symbol->color-id color) "m"
                      str ... "\x1b[39m")]))

  (define-syntax red
    (syntax-rules ()
      [(red str ...)
       (in-color 'red str ...)]))

  (define-syntax green
    (syntax-rules ()
      [(green str ...)
       (in-color 'green str ...)]))


  (define (user-say-string user text)
    (string-append (get-username-string user) " | " text))


  (define (user-yell-string user text)
    (string-append (get-username-string user) (red " !! ") text))


  (define (user-left-string user)
    (string-append info-exclemation "user "
                   (get-username-string user) " has left the world. R.I.P."))


  (define (user-moved-to-string user)
    (string-append info-exclemation "user "
                   (get-username-string user) " has moved to "
                   (green (symbol->string (car (user-place user))))))


  (define (user-moved-from-string user)
    (string-append info-exclemation "user "
                   (get-username-string user) " has moved in from "
                   (green (symbol->string (car (user-place user))))))


  (define (user-name-change-string old-name user)
    (string-append info-exclemation "user "
                   (in-color (user-color user) old-name) " is now known as "
                   (get-username-string user)))


  (define (user-name-change-string old-name user)
    (string-append info-exclemation "user "
                   (in-color (user-color user) old-name) " is now known as "
                   (get-username-string user)))


  (define (user-color-change-string old-color user)
    (string-append info-exclemation "user "
                   (in-color old-color (user-name user)) " is now known as "
                   (get-username-string user)))


  (define (print-colors)
    (for-each
      (lambda (color-pair)
         (in-color (cadr color-pair) (car color-pair)))
      colors))


  (define (valid-color? color)
    (not (null? (filter
                  (lambda (color-pair) (equal? (car color-pair) color))
                  colors))))


  (define (get-username-string user)
    (in-color (user-color user) (user-name user))))


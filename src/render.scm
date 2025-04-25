(module render (user-left-string
                user-say-string user-yell-string
                info-exclemation
                print-colors valid-color?
                red)
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


  (define-syntax red
    (syntax-rules ()
      [(red str ...)
       (string-append "\x1b[31m" str ... "\x1b[39m")]))


  (define (user-say-string user text)
    (string-append (get-username-string user) " | " text))


  (define (user-yell-string user text)
    (string-append (get-username-string user) (red " !! ") text))


  (define (user-left-string user)
    (string-append info-exclemation "user "
                   (get-username-string user) " has left"))


  (define (print-colors)
    (for-each
      (lambda (color-pair)
         (print "\x1b[" (cadr color-pair) "m" (car color-pair) "\x1b[0m"))
      colors))


  (define (valid-color? color)
    (not (null? (filter
                  (lambda (color-pair) (equal? (car color-pair) color))
                  colors))))


  (define (get-username-string user)
    (string-append "\x1b[" (symbol->color-id (user-color user)) "m"
                   (user-name user) "\x1b[39m"))

  (define (symbol->color-id sym)
    (let ((item (filter (lambda (x) (eqv? sym (car x))) colors)))
      (if (null? item) "39" (cadar item)))))


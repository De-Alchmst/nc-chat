(module render (get-username-string)
  (import scheme (chicken base)
          srfi-1
          user) 

  (define colors '((red      "31")
                   (green    "32")
                   (yellow   "33")
                   (blue     "34")
                   (magenta  "35")
                   (cyan     "36")
                   (white    "37")

                   (bred     "41")
                   (bgreen   "42")
                   (byellow  "43")
                   (bblue    "44")
                   (bmagenta "45")
                   (bcyan    "46")
                   (bwhite   "47")))


  (define (get-username-string user)
    (string-append "\x1b[" (symbol->color-id (user-color user)) "m"
                   (user-name user) "\x1b[39m"))

  (define (symbol->color-id sym)
    (let ((item (filter (lambda (x) (eqv? sym (car x))) colors)))
      (if (null? item) "39" (cadar item)))))


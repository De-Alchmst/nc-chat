;; THIS FILE IS USED TO ISOLATE LOADED CODE FROM THE REST OF CODEBASE
;; IT SHOULD NOT BE NEEDED, BUT I'M STILL AFRAID...

(module load-worlds (motd)
  (import scheme (chicken base)
          (chicken process-context) (chicken file) (chicken irregex)
          (chicken pathname))

  (find-files (make-pathname (pathname-directory (executable-pathname)) "data")
              #:test (irregex ".+\\.(?:ss|scm)+")
              #:limit #f
              #:dotifles #t
              #:follow-symlinks #t
              #:seed '()
              #:action (lambda (file _)
                         (load file)))


  ;; dark magic required to get the symbol to module scope
  (define motd (eval 'motd)))

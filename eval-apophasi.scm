#!r6rs

(import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6))
  (rnrs io simple (6))
  (srfi :64)
  (apophasi apophasi))

(define repl
  (lambda ()
    (display "Apophasi test REPL")
    (let loop ((env '()))
      (display)
      (display #\newline)
      (display #\newline)
      (display ">>> ")
      (let ((result (apophasi:eval (read) env)))
        (display (car result))
        (loop (cdr result))))))

(repl)

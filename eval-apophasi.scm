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
    (display ">>> ")
    (display (apophasi:eval (read) '()))
    (display #\newline)
    (repl)))

(repl)

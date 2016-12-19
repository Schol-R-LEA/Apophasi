#!r6rs

(import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6))
  (rnrs io simple (6))
  (srfi :64)
  (apophasi apophasi))

(define runner (test-runner-simple))

(test-with-runner runner 
  (test-group
   "Test atomic expressions"
   (test-group
    "Basic matcher generation - a single atomic rule"
    (assert-equal? 1 (apophasi:eval 1 '())))))

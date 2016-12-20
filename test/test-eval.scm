#!r6rs

(import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6))
  (rnrs io simple (6))
  (srfi :64)
  (apophasi apophasi))

(define runner (test-runner-simple))

(test-with-runner
 runner
 (test-group
  "evaluator tests"
 (test-group
  "Common failure modes"
  (test-assert
   "inline arithmetic"
   (guard (con
           ((apophasi-syntax-error? con)
            (begin
              (display (apophasi-syntax-error-irritant con))
              (display #\newline)
              #t)))
          (apophasi:eval '(1 + 1) '()))))
 (test-group
  "Test atomic expressions"
  (test-group
   "self-evaluating expressions"
   (test-equal "integer" 1 (apophasi:eval 1 '()))
   (test-equal "hex integer" #xDEADBEEF (apophasi:eval #xDEADBEEF '()))
   (test-equal "flonum" 3.1415 (apophasi:eval 3.1415 '()))
   (test-equal "rational number" 17/23 (apophasi:eval 17/23 '()))
   (test-equal "complex number" 5+42i (apophasi:eval 5+42i '()))
   (test-equal "character" #\a (apophasi:eval #\a '()))
   (test-equal "character constant" #\newline (apophasi:eval #\newline '()))
   (test-equal "string" "Why not go mad?" (apophasi:eval "Why not go mad?" '()))
   )
  (test-group
   "quoted expressions"
   (test-equal "quoted symbol" `foo (apophasi:eval 'foo '()))
   (test-equal "quoted list of numbers"
               '(1 2)
               (apophasi:eval '(1 2) '()))
   (test-equal "quoted list of symbols"
               '(foo bar)
               (apophasi:eval '(foo bar) '()))
   (test-equal "quoted nested list of symbols"
               '((foo) (bar baz) quux)
               (apophasi:eval '((foo) (bar baz) quux) '()))
   ))))

#!r6rs

(import
 (rnrs (6))
 (rnrs base (6))
 (rnrs eval (6))
 (rnrs io simple (6))
 (srfi :64)
 (apophasi dispatch-table))

(define runner (test-runner-simple))

(test-with-runner
 runner
 (test-group
  "dispatch table tests"
  (let* ((foo (lambda (bar) (+ 1 (car bar))))
         (baz (lambda (bar) (- 1.0 (car bar))))
         (quux (lambda (bar) (* (car bar) (cadr bar))))
         (foo? (lambda (bar) (integer? (car bar))))
         (baz? (lambda (bar) (real? (car bar))))
         (quux? (lambda (bar) (and (complex? (car bar)) (complex? (cadr bar)))))
         (simple-table (make-dispatch-table (foo? foo)))
         (simple-table-list (simple-table '() '()))
         (simple-match (list (list foo? foo)))
         (table (make-dispatch-table (foo? foo)
                                     (baz? baz)
                                     (quux? quux)))
         (table-list (table '() '()))
         (match (list (list foo? foo)
                      (list baz? baz)
                      (list quux? quux)))
         (pie 3.1415)
         (pie-slice (baz (list pie))))
    (test-group
     "table construction"
     (test-equal "single-entry table" simple-table-list simple-match)
     (test-equal "multiple-entry table" table-list match))
    (test-group
     "test dispatching from table"
     (test-equal
      "directly dispatching from table closure with an integer argument"
      2 (table 'dispatch (list 1)))
     (test-equal
      "indirectly dispatching from defined table type with an integer argument"
      2 (dispatch table 1))
     (test-equal
      "directly dispatching from table closure with a flonum argument"
       pie-slice (table 'dispatch (list pie)))
     (test-equal
      "indirectly dispatching from defined table type with a flonum argument"
      pie-slice (dispatch table pie))
     (test-equal
      "directly dispatching from table closure with a complex argument"
      1+3i (table 'dispatch (list 2+1i 1+1i)))
     (test-equal
      "indirectly dispatching from defined table type with a pair of complex arguments"
1+3i (dispatch table 2+1i 1+1i))))))
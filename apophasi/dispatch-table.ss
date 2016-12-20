#!r6rs

(library
 (apophasi dispatch-table)
 (export
  make-dispatch-table dispatch add-dispatch-entry
  &dispatch-table-lookup-failed
  make-dispatch-table-lookup-failed dispatch-table-lookup-failed?
  dispatch-table-lookup-failed-irritant)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6))
  (rnrs lists (6))
  (rnrs exceptions (6))
  (rnrs conditions (6)))
 
 
 (define-condition-type &dispatch-table-lookup-failed &condition
   make-dispatch-table-lookup-failed
   dispatch-table-lookup-failed?
   (irritant-expression dispatch-table-lookup-failed-irritant))


 (define predicate-lookup
   (lambda (alist arg-list)
     (assp
      (lambda (alist)
        (alist arg-list))
      alist)))
 
 (define make-dispatch-table-closure
   (lambda (table)
     (lambda (method arg-list)
       (case method
         ('dispatch
          (let ((match (predicate-lookup table arg-list)))
            (if (list? match)
                ((cadr match) arg-list)
                (raise-continuable
                 (condition
                  (make-dispatch-table-lookup-failed arg-list)
                  (make-message-condition
                   "Could not find a matching dispatch entry"))))))
         ('add
          (set! table (append table arg-list)))
         (else table)))))
 
 (define-syntax make-dispatch-table
   ;; Create a closure around an alist for automating table dispatch
   (syntax-rules ()
     ((_ (<pred-n> <dispatch-n>) ...)
      (make-dispatch-table-closure
       (list
        (list <pred-n> <dispatch-n>)
        ...)))))
 
 (define dispatch
   (lambda (table . args)
     (table 'dispatch args)))
 
 (define add-dispatch-entry
   (lambda (table pred evaluator)
     (table 'add (list pred evaluator))))



(define (foo bar) (+ 1 (car bar)))
(define (baz bar) (- 1 (car bar)))
(define (quux bar) (* (car bar) (cadr bar)))

(define t (list (list integer? foo) (list real? baz) (list complex? quux))))


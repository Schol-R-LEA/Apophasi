#!r6rs

(library
 (apophasi dispatch-table)
 (export make-dispatch-table
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
   (lambda (table table-miss-handler)
     (lambda (method arg-list)
       (case method
         ('dispatch
          (let ((match (predicate-lookup table arg-list)))
            (if (list? match)
                ((cadr match) arg-list)
                (table-miss-handler arg-list))))
         ('add
          (set! table (append table arg-list)))
         (else table)))))
 

 (define-syntax make-dispatch-table
   ;; Create a closure around an alist for automating table dispatch
   (syntax-rules ()
     ((_ ((<pred-n> <dispatch-n>) ...) <table-miss-handler>)
      (make-dispatch-table-closure
       (list
        (list <pred-n> <dispatch-n>)
        ...)
       <table-miss-handler>))
     ((_ ((<pred-n> <dispatch-n>) ...))
      (make-dispatch-table ((<pred-n> <dispatch-n>) ...)
                           (lambda ()
                             (raise-continuable
                              (condition
                               (make-dispatch-table-lookup-failed arg-list)
                               (make-message-condition
                                "Could not find a matching dispatch entry"))))))
     ((_ (<pred> <dispatch>) <table-miss-handler>)
      (make-dispatch-table ((<pred> <dispatch>)) <table-miss-handler>))
     ((_ (<pred> <dispatch>))
      (make-dispatch-table ((<pred> <dispatch>)))))))

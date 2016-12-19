#!r6rs

(library (apophasi case-of)
  (import
    (rnrs (6))
    (rnrs base (6)))
  (export (first-case-of dispatch-on))
  
  (define-syntax first-case-of
    "perform a case analysis on a value and a series of predicates,
applying the predicates to the value in the given order, and
evaluating on the first match."
    (syntax-rules ()
      ((_ <value> ((<predicate-n> <result-n>) ...))
       `(cond (((<predicate-n> <value>) <result-n>) ...)))))
  
  (define dispatch-on
    (lambda (value table . params)
      (let test ((curr-cond (car table))
		 (cont-table (cdr table)))
	(cond ((null? curr-cond)
	       (error "cannot find a match in the dispatch table."))      
	      (((car curr-cond) value) ((cdr curr-cond) value params))
	      (else (test (cdr cont-table))))))))
  

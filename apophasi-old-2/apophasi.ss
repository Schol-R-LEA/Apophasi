#!r6rs
(library
 (apophasi apophasi)
 (export
  apophasi:eval
  &apophasi-syntax-error
  make-apophasi-syntax-error apophasi-syntax-error? apophasi-syntax-error-irritant)
 (import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6))
  (rnrs exceptions (6))
  (rnrs conditions (6))
  (apophasi dispatch-table))
 
 (define self-evaluating?
   (lambda (arg-list env)
     (let ((expr (car arg-list)))
       (or (number? expr)
           (string? expr)
           (char? expr)))))
 
 (define id
   (lambda (arg-list env) 
     (car arg-list)))
 
 (define lexer-expansion?
   (lambda (arg-list env)
     #f))
 
 (define expand-read-macro
   (lambda (arg-list env)
     #f))
 
 (define parser-expansion?
   (lambda (arg-list env)
     #f))
 
 (define expand-macro
   (lambda (arg-list env)
     #f))
 
 (define variable?
   (lambda (arg-list env)
     #f))
 
 (define get-value
   (lambda (arg-list env)
     #f))
 
 (define quoted?
   (lambda (arg-list env)
     #f))
 
 (define get-quoted-expr
   (lambda (arg-list env)
     #f))
 
 (define quasiquoted?
   (lambda (arg-list env)
     #f))
 
 (define get-qq-expr
   (lambda (arg-list env)
     #f))
 
 (define spliced?
   (lambda (arg-list)
     #f))
 
 (define get-spliced-value
   (lambda (arg-list env)
     #f))
 
 (define assignment?
   (lambda (arg-list env)
     #f))
 
 (define rebind
   (lambda (arg-list)
     #f))
 
 (define simple-conditional?
   (lambda (arg-list)
     #f))
 
 (define select
   (lambda (arg-list)
     #f))
 
 (define complex-conditional?
   (lambda (arg-list)
     #f))
 
 (define multi-select
   (lambda (arg-list)
     #f))
 
 (define case-conditional?
   (lambda (arg-list)
     #f))
 
 (define case-select
   (lambda (arg-list)
     #f))
 
 (define match-conditional?
   (lambda (arg-list)
     #f))
 
 (define domain-select  
   (lambda (arg-list)
     #f))
 
 (define lambda?
   (lambda (arg-list)
     #f))
 
 (define make-procedure
   (lambda (arg-list)
     #f))
  
 (define scoped-procedure?
   (lambda (arg-list)
     #f))
 
 (define apply-procedure
   (lambda (arg-list)
     #f))
 
 (define empty-handler
   (lambda (args-list)
     'NO-MATCH))
 
 (define valid?
   (lambda (result)
     (not (equal? result 'NO-MATCH))))
 
 (define macro-eval-dispatch-table
   (make-dispatch-table
    ;; the first two, which handle macros,
    ;; *must* come before all other cases.
    ((lexer-expansion? expand-read-macro)
     (parser-expansion? expand-macro))
    ; return 'NO-MATCH if no result
    empty-handler))
 
 (define atom-eval-dispatch-table
   (make-dispatch-table    
    ((self-evaluating? id)
     (quoted? get-quoted-expr)
     (quasiquoted? get-qq-expr)
     (spliced? get-spliced-value))
    ; return 'NO-MATCH if no result
    empty-handler))
 
 (define special-form-dispatch-table
   (make-dispatch-table
    ((assignment? rebind)
     (simple-conditional? select)
     (complex-conditional? multi-select)
     (case-conditional? case-select)
     (match-conditional? domain-select)
     (lambda? make-procedure)
     (scoped-procedure? apply-procedure))
    ; return 'NO-MATCH if no result
    empty-handler))
 
 (define (apophasi:eval expr env)
   "Evaluator for the Apophasi sub-set of the Thelema language."
   
   ;; first, check to see if it is a macro or read macro,
   ;; and if so, apply it
   (let ((macro-eval-result (macro-eval-dispatch-table 'dispatch expr env)))
     (if (valid? macro-eval-result)
         macro-eval-result
         (let ((atom-eval-result ( atom-eval-dispatch-table 'dispatch expr env)))
           (if (valid? atom-eval-result)
               atom-eval-result
               ; if the expression is not an atom or other
               ; self-evaluating form such as a quote,
               ; try to dispatch it from the special forms
               (let ((special-eval-result (special-form-dispatch-table 'dispatch  expr env)))
                 (if (valid? special-eval-result)
                     (cons env special-eval-result)
                     (raise-continuable
                      (condition
                       (make-apophasi-syntax-error expr)
                       (make-message-condition
                        "EVAL - could not evaluate sub-expression"))))))))))
 
 (define-condition-type &apophasi-syntax-error &condition
   make-apophasi-syntax-error apophasi-syntax-error?
   (irritant-expression apophasi-syntax-error-irritant)))


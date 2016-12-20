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
  (rnrs conditions (6)))

 

 
 (define (self-evaluating? expr)
   (or (number? expr)
       (string? expr)
       (char? expr)))
 
 (define (id expr env)
   expr)
 
 (define (lexer-expansion? expr env)
   #f)
 
 (define (expand-read-macro expr env)
   '())


  (define (parser-expansion? expr env)
   #f)
 
 (define (expand-macro expr env)
   '())
 
 (define (variable? expr)
   #f)
 
 (define (get-value expr env)
   '())
 
 (define (quoted? expr)
   #f)
 
 (define (get-quoted-expr expr env)
   '())
 
 (define (assignment? expr)
   #f)
 
 (define (rebind expr env)
   '())
 
 (define (simple-conditional? expr)
   #f)
 
 (define (select expr env) expr)
 
 
 (define (complex-conditional? expr)
   #f)
 
 (define (multi-select expr env)
   '())
 
 (define (case-conditional? expr)
   #f)
 
 (define (case-select expr env)
   '())
 
 (define (match-conditional? expr)
   #f)
 
 (define (domain-select expr env)
   '())
 
 (define (lambda? expr)
   #f)
 
 (define (make-procedure expr env)
   '())
 
 (define eval-dispatch-table
   (list
    ;; the first two, which handle macros,
    ;; *must* come before all other cases.
    (list lexer-expansion? expand-read-macro)
    (list parser-expansion? expand-macro)
    (list self-evaluating? id)
    (list quoted? get-quoted-expr)
    (list apophasi:symbol? eval-value)))

 (define special-form-dispatch-table
   (list
    (list assignment? rebind)
    (list simple-conditional? select)
    (list complex-conditional? multi-select)
    (list case-conditional? case-select)
    (list match-conditional? domain-select)
    (list lambda? make-procedure)))
 
 (define (apophasi:eval expr env)
   (let ((match (assp
                 (lambda (assoc)
                   (assoc expr))
                 eval-dispatch-table)))
     (if (list? match)
         ((cadr match) expr env)
         (raise-continuable
          (condition
           (make-apophasi-syntax-error expr)
           (make-message-condition
            "Could not evaluate expression"))))))
 
 (define-condition-type &apophasi-syntax-error &condition
   make-apophasi-syntax-error apophasi-syntax-error?
   (irritant-expression apophasi-syntax-error-irritant)))


#!r6rs

(import
  (rnrs (6))
  (rnrs base (6))
  (rnrs eval (6)))

(define (self-evaluating? expr)
  #f)

(define (id expr env)
  expr)

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
   (list self-evaluating? id)
   (list variable? get-value)
   (list quoted? get-quoted-expr)
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
	((cdr match) expr env)
	(error "Could not evaluate expression" expr))))

(apophasi:eval 1 '())



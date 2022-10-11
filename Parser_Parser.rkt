
#lang racket
;expand env
;(set' env(cons (x (resolve env 'a)) env))

;(resolve env 'a)

; (call (function (x) x)) a) → (app-exp (func-exp (params x) (body-exp x) (var-exp a)

(define neo-parser
  (lambda (neo-code)
    (cond
      ((null? neo-code) '())
      ((number? neo-code) (list 'num-exp neo-code))
      ((symbol? neo-code) (list 'var-exp neo-code))
      ;(bool op num1 num2) > (bool-exp op (neo-exp) (neo-exp))
       ((equal? (car neo-code) 'bool)(neo-bool-code-parser neo-code))
      ;(math op num1 num2) > (math-exp op (neo-exp) (neo-exp))
      ((equal? (car neo-code) 'math) (neo-math-code-parser neo-code))
      ;(ask (bool op num1 num2) (neo-exp1) (neo-exp2)) > (ask-exp (bool-exp ...) (parsed-neo-exp1) (parsed-neo-exp2))
      ((equal? (car neo-code) 'ask)(neo-ask-code-parser neo-code))
      ;(function (x y z,...) x)
      ((equal? (car neo-code) 'function) (neo-call-code-parser neo-code))
      ;(call (function (x y z) (math + (math + x y) z)) (1 2 3)) ->
      ;(app-exp (func-exp (params (identifier1, identifier2, identifer3 ...)) (body-exp)) ((neo-exp1 neo-exp2 neo-exp3 ...))
      ((equal? (car neo-code) 'call) (neo-call-code-parser neo-code))
      (else (map neo-parser neo-code)) ;((neo-parser 1) (neo-parser 'a) (neo-parser (math + 1 2)))
      )
    )
  )


(define reverse-parser
  (lambda (parsed-code)
    (cond
          ((equal? (car parsed-code) 'var-exp) (cadr parsed-code)) ; (var-exp a) ->a
          ((equal? (car parsed-code) 'params) (cadr parsed-code))
          ((equal? (car parsed-code) 'body-exp) (reverse-parser(cadr parsed-code)))
          ((equal? (car parsed-code) 'func-exp)(list 'function (reverse-parser
                                      (car (cdr parsed-code))) (reverse-parser (caddr parsed-code))))
          (else (list 'call (reverse-parser (cadr parsed-code)) (reverse-parser (caddr parsed-code)))))))


(define neo-bool-code-parser
  (lambda (bool-code)
    (if (equal? (length bool-code) 3)
            (list 'bool-exp (cadr bool-code) (neo-parser (caddr bool-code)) '())
        (cons 'bool-exp (cons (cadr bool-code) (map neo-parser (cddr bool-code)))))))


(define neo-math-code-parser
  (lambda (math-code)
     (list 'math-exp (cadr math-code)
             (neo-parser (caddr math-code))
             (neo-parser (cadddr math-code)))))


(define neo-func-code-parser
  (lambda (func-code)
    (list 'func-exp
          (list 'params (cadr func-code))
          (list 'body-exp (neo-parser (caddr func-code))))))


(define neo-ask-code-parser
  (lambda (ask-code)
     (cons 'ask-exp
             (map neo-parser (cdr ask-code)))))

 (define neo-call-code-parser
  (lambda (call-code)
    (list 'app-exp
             (neo-parser (cadr call-code))
             (neo-parser (caddr call-code)))))



;(define sample-code '(call (function(x) (math + x 1)) 4))
;(define sample-code '(call (function(x y z)(math + (math + x y) z)) (1 2 3)))
;(display (neo-parser sample-code))



(provide (all-defined-out))

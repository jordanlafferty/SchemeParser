#lang racket
; resolve a value from a variable environment
(define resolve
  (lambda (environment varname)
    (cond
      ((null? environment) #false)
      ((equal? (car (car environment)) varname) (cadar environment))
      (else (resolve (cdr environment) varname)))))



(define run-neo-parsed-code
  (lambda (parsed-code env)
    (cond
      ((null? parsed-code) '())
      ((equal? (car parsed-code) 'num-exp) (cadr parsed-code))
      ((equal? (car parsed-code) 'var-exp) (resolve env (cadr parsed-code)))
      ((equal? (car parsed-code) 'bool-exp) (run-bool (cadr parsed-code)
                     (run-neo-parsed-code (caddr parsed-code) env)
                     (run-neo-parsed-code (cadddr parsed-code) env)))
       ((equal? (car parsed-code) 'ask-exp)
           (if (run-neo-parsed-code (cadr parsed-code) env)
           (run-neo-parsed-code (caddr parsed-code) env)
           (run-neo-parsed-code (cadddr parsed-code) env)))
      ((equal? (car parsed-code) 'math-exp) (run-math (cadr parsed-code)
                     (run-neo-parsed-code (caddr parsed-code) env)
                     (run-neo-parsed-code (cadddr parsed-code) env)))
      ((equal? (car parsed-code) 'func-exp) (run-neo-parsed-code (cadr (caddr parsed-code)) env))
       (else (run-neo-parsed-code (cadr parsed-code)(extend-env
              (cadr (cadr (cadr parsed-code))) (map (lambda (exp)
              (run-neo-parsed-code exp env)) (caddr parsed-code)) env))))))

(define extend-env
  (lambda (vars vals env)
    (cond ((or (null? vars) (null? vals)) env)
          (else (extend-env (cdr vars) (cdr vals)
                            (cons (list (car vars) (car vals)) env))))))
(require "Parser_Utility.rkt")
; tool to deal with bools
(define run-bool
  (lambda (op num1 num2)
    (cond
      ((equal? op '>) (> num1 num2))
      ((equal? op '<) (< num1 num2))
      ((equal? op '>=) (>= num1 num2))
      ((equal? op '<=) (<= num1 num2))
      ((equal? op '==) (= num1 num2))
      ((equal? op '!=) (not (= num1 num2)))
      ((equal? op '&&) (and num1 num2))
      ((equal? op '||) (or num1 num2))
      ((equal? op '!) (not num1 0))
      (else #false))))


; tool to deal with math
(define run-math
  (lambda (op num1 num2)
    (cond
      ((equal? op '+) (+ num1 num2))
      ((equal? op '-) (- num1 num2))
      ((equal? op '*) (* num1 num2))
      ((equal? op '/) (/ num1 num2))
      ((equal? op '//) (quotient num1 num2))
      ((equal? op '%) (modulo num1 num2))
      (else #false))))

(provide (all-defined-out))
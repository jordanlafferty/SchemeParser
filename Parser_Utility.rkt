#lang racket
;function to get something similar to indexOf()
(define elementAt
  (lambda (lst index)
    (cond
      ((not (list? lst)) "this is not a list")
      ((null? lst) "this is an empty list or index is out of bounds")
      ((equal? index 0) (car lst))
      (else (elementAt (cdr list) (- index 1))))))


(define getVarnames
  (lambda (lst)
    (if (null? lst) '()
        (cons (car (car lst)) (getVarnames (cdr lst))))))

(define getValues
  (lambda (lst)
    (if (null? lst) '()
        (cons (car (cdr (car lst))) (getValues (cdr lst)))
        )))

(provide (all-defined-out))

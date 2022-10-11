#lang racket
;function to get something similar to indexOf()
(define elementAt
  (lambda (lst index)
    (cond
      ((not (list? lst)) "this is not a list")
      ((null? lst) "this is an empty list or index is out of bounds")
      ((equal? index 0) (car lst))
      (else (elementAt (cdr list) (- index 1))))))



(provide (all-defined-out))
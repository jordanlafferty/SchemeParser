#lang racket

(require "Parser_Utility.rkt")
(require "Parser_Parser.rkt")
(require "Parser_Runner.rkt")

(define env '((global (a 1) (b 2) (c 5))))
;(run-neo-parsed-code (neo-parser '(call (function (a) (call (function (r) a ) (a))) (5))) env)


(define sample-code '(print a));
;(define sample-code2 '(assign a));
;(define sample-code '(local-vars ((a 7) (b a) (x b)) (math + x a)))
(displayln (neo-parser sample-code))
(define parsed-neo-code (neo-parser sample-code))
(run-neo-parsed-code parsed-neo-code env)

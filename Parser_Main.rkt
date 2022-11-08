#lang racket

(require "Parser_Utility.rkt")
(require "Parser_Parser.rkt")
(require "Parser_Runner.rkt")

(define env '((global (a 1) (b 2) (c 5))))
(run-neo-parsed-code (neo-parser '(call (function (a) (call (function (r) a ) (a))) (5))) env)

;(define env '((a 1) (b 2) (c 5)))
;(define sample-code '(call (function () (ask (bool != a b) (math - a b) (math - a b))) (a)))
;(display (neo-parser sample-code))
;(display(run-neo-parsed-code (neo-parser sample-code) env))

;(define parsed-neo-code (neo-parser '(call (function(a) (local-vars ((x 5) (y 6) (z 9)) (function (b)(math + a (math * b x))))) (2))))


;(run-neo-parsed-code parsed-neo-code env)

(provide (all-defined-out))

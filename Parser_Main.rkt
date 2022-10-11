#lang racket

(require "Parser_Utility.rkt")
(require "Parser_Parser.rkt")
(require "Parser_Runner.rkt")

(define env '((a 1) (b 2) (c 5)))
(define sample-code '(call (function () (ask (bool != a b) (math - a b) (math - a b))) (a)))
(display (neo-parser sample-code))
(display(run-neo-parsed-code (neo-parser sample-code) env))

(provide (all-defined-out))
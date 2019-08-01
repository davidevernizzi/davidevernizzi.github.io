---
layout: post
title:  "FizzBuzz in Clojure"
date:   2019-01-01
tags: [clojure kata fizzbuzz]
---

Taking inspiration from [this](http://iolivia.me/posts/fizzbuzz-in-10-languages/) great post of fizzbuzz written in 10 languages, I have decided to write it in Clojure.

The basic version is pretty simple, and fairly similar to the on proposed in Haskell:

```clojure
(defn fb? [c]
 (cond
  (= 0 (+ (rem c 3) (rem c 5))) "fizzbuzz"
  (= 0 (rem c 3)) "fizz"
  (= 0 (rem c 5)) "buzz"
  :else c
 )
)

(map fb? (range 1 16))
; (1 2 "fizz" 4 "buzz" "fizz" 7 8 "fizz" "buzz" 11 "fizz" 13 14 "fizzbuzz")
```

A more interesting version is one that uses [lazy sequences](https://clojure.org/reference/lazy):

```clojure
(defn fb? [c]
 (cond
  (= 0 (+ (rem c 3) (rem c 5))) "fizzbuzz"
  (= 0 (rem c 3)) "fizz"
  (= 0 (rem c 5)) "buzz"
  :else c
 )
)

(defn lazyfb 
 ([] (lazyfb 1))
 ([n] (lazy-seq (cons (fb? n) (lazyfb (inc n)))))
)

(take 15 (lazyfb))
; (1 2 "fizz" 4 "buzz" "fizz" 7 8 "fizz" "buzz" 11 "fizz" 13 14 "fizzbuzz")
```


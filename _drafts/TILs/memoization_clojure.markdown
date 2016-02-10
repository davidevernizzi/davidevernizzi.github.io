I learnt that it's not that easy to memoize in clojure.
Or, better, it's trivial, but you have to use the `memoize` function,
otherwise you should modify the variable where you store the memoized functions. Which is forbidden in clojure.

Therefore the memoized version of fibo is:

```Clojure
(def m-fib
 (memoize (fn [n]
           (condp = n
            0 1
            1 1
            (+ (m-fib (dec n)) (m-fib (- n 2)))))))
```

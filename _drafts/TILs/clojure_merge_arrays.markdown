This merges two vectors in clojure:

```Clojure
(filter (set [1 2 3]) [2 3 4])
; (2 3)
```

This works because `(set [1 2 3])` transforms the first vector into a set `#{1 2 3}`,
which when used as a function with a value, returns the value if it is present in the 
set, `nil` otherwise. Together with the `filter` it returns a set made of the intersection
between the two original vectors.

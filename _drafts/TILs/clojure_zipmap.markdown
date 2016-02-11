`zipmap` is a nice way to create a map out of 2 sets: the first one for keys, the other for values.

```Clojure
(zipmap ["name" "location" "age"] ["dave" "italy" 35])
; => {"name" "dave", "location" "italy", "age" 35}
```

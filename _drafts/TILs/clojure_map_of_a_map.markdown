Mapping the result of a map was not that trivial. Here is a super simplified code to map each cell of a matrix:

```Clojure
(let [matrix [[1 2 3][4 5 6][7 8 9]]]
   (map 
      (fn [row] 
         (map 
            (fn [cell] (+ 1 cell)) 
	    row
         )
      ) 
      matrix
   )
)
```

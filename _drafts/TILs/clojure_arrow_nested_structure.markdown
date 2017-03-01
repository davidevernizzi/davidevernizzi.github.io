In Clojure the arrow function can be used to access a nested data structure:

```Clojure
(def m {:person {
           :address {
              :city "New York"
              :street "5th Avenue"
           }
        }})
(-> m :person :address :city)
; "New York"
```

To run a single test in Clojure type:

```
lein test :only myProject.selectedTessuite/testname
```

Unfortunately it does not support wildchar or regexp to specify multiple tests withing a testsuite. This can be done by overriding the test hook:

```Clojure
(deftest test-ns-hook []
  (selectedTest1)
  (selectedTest2)
)
```

and then 

```
lein test myProject.selectedTessuite
```

Note that this will always run only `selectedTest1` and `selectedTest2` since we explicitly overridden the test hook.

---
layout: post
title:  "Routes in ClojureScript"
date:   2016-12-XX
categories: clojurescript
---

I'm experimenting with Clojurescript; Clojurescript is wonderful (just as Clojure is)
and with (Reagent)[http://reagent-project.github.io] it is lots of fun.
Unfortunately as for much of the Clojure-world there is not much documentation, but
there is a very handy (recipe book)[https://github.com/reagent-project/reagent-cookbook]
that together with the basic documentation should get you up and running.

I have created a toy application to play with; it has some views and some basic routing.
After a while I have refactored the code to separate views and routing from the core
and move them into separate files, so to allow modularity.

Moving the code has been very easy (just copy and paste from the examples); the routing
was slighlty more trickier, but nothing too complex. Here's how I did it.

I created the following function into each module (let's say a blog section) I want to add,

```clojure
(ns clojurescript-test.blog
  (:require-macros [secretary.core :refer  [defroute]])
  (:require [reagent.core :as reagent]
            )
  )

(defn main-component []
  [:div
   "This is my blog ..."
   ])

(defn add-routes [current-page app-state]
  (defmethod current-page :blog [] [main-component])
    (defroute "/blog" [] (swap! app-state assoc :page :blog))
      )
```

and then in the `core.cljs` file I just include the module

```clojure
(ns clojurescript-test.core
  (:require-macros [secretary.core :refer  [defroute]])
  (:import goog.History)
  (:require [reagent.core :as reagent]
            [secretary.core :as secretary]
            [clojurescript-test.blog :as blog]
            ))
```

and call the function of the module

```clojure
  (blog/add-routes current-page app-state)
```

and that's all.

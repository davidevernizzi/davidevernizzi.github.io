---
layout: post
title:  "Arbitrary Number Of parameters With Compojure"
date:   2017-04-03
categories: clojure, API
---

I wanted to create an API in CLokure/Compojure that accepted an arbitrary number or parameters. I'm using Luminus framework, and I have generated an app using the `+service` template, which creates a RESTful API (see [here](http://www.luminusweb.net/docs/services.md) for details).

The API uses [compojure-api](https://github.com/metosin/compojure-api) which is based on [compojure](https://github.com/weavejester/compojure) which uses [clout](https://github.com/weavejester/clout) as routing syntax.

Compojure supports [regular expression](https://github.com/weavejester/compojure/wiki/Routes-In-Detail#matching-the-uri) to define parameters, so it's quite straightforward to use them in compojure-api:

```Clojure
     (GET "/foo/first/:first/:others{.*}" []
          :return s/Any
          :path-params [first :- s/Any others :- s/Any]

          (ok (str "First: " first " Others: " others))
          )
```

That's it.

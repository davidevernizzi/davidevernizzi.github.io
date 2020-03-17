---
layout: post
title:  "Browser fingerprinting"
date:   2020-03-05
tags: []
---

Browser fingerprinting is a particularly nasty technique 
for identifying and tracking an individual computer by collecting data regarding the configuration of a user’s browser and system when they visit a website. The construction of a browser fingerprint can be done using different technologies, making it difficult to avoid across websites [[WIKI]](https://en.wikipedia.org/wiki/Browser_fingerprint).

Fingerprinting poses particular threats to privacy because it relies on information that cannot be easily reset by a user, and, therefore, it is difficult to avoid or mitigate.
The topic is under active investigation, both by academic research (e.g. see [[LAPERDRIX]](https://arxiv.org/abs/1905.01051)), by the [W3C](https://w3c.github.io/fingerprinting-guidance/), and, of course, by private companies (see, for instance, [FingerprintJS](https://fingerprintjs.com/)).

Many browsers claim to implement protection (e.g. [[FIREFOX]](https://blog.mozilla.org/security/2020/01/07/firefox-72-fingerprinting/) and [[BRAVE]](https://brave.com/brave-fingerprinting-and-privacy-budgets/)), but an empiric test showed that all the major browsers (Chrome, FF, Safari, Brave) with default configurations are easily identified both by [Nothing Private](https://www.nothingprivate.ml/) and [Panopticlick](https://panopticlick.eff.org/). A much more effective way is to run the browser inside a virtual machine or a docker image, but this solution is clearly not feasible for the average user.

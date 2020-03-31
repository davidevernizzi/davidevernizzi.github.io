---
layout: post
title:  "Browser fingerprinting"
date:   2020-03-30
tags: []
---

Browser fingerprinting is a nasty technique 
for identifying and tracking an individual computer by collecting data of the configuration of a user’s browser and system when they visit a website.
The problem is  hideous because the fingerprint of a browser is computed using [different technologies](https://en.wikipedia.org/wiki/Browser_fingerprint), making it difficult to avoid across websites.

The usual usage of browser fingerprinting is to track users among different sessions, even when they disable cookies or clean browsers cache. It goes like this: a user visits a website which runs a fingerprinting script. The script computes the fingerprint, a long number, which is unique to that single browser, running on that compute, and stores it the website database. When the user visits again the site in a later session, the fingerprint is computed again and, since the user had previously visited the site, it matches the previous session. The website can then track the user among different sessions, even without the help of cookies.

Fingerprinting poses particular threats to privacy because it relies on information that cannot be easily reset by a user, and is difficult to avoid or mitigate.
The topic is under active investigation, both by [academic research](https://arxiv.org/abs/1905.01051), by the [W3C](https://w3c.github.io/fingerprinting-guidance/), and, of course, by private companies (see, for instance, [FingerprintJS](https://fingerprintjs.com/)).

Many browsers claim to protect users (e.g. [Firefox](https://blog.mozilla.org/security/2020/01/07/firefox-72-fingerprinting/) and [Brave](https://brave.com/brave-fingerprinting-and-privacy-budgets/)), but an empiric test showed that all the major browsers (Chrome, FF, Safari, Brave) with default configurations are easily identified both by [Nothing Private](https://www.nothingprivate.ml/) and [Panopticlick](https://panopticlick.eff.org/).

Browser fingerprinting is the natural result of ugly [business models](https://www.vernizzis.it/On-Business-Models), which convinced millions of people that online services can be free, and supported by just a "little bit of advertising".

---
layout: post
title:  "PHP does not come with a proper json parser in Centos and it must be manually installed"
---

I installed PHP on a Centos box and then installed WordPress and the installation failed because PHP could not find the function `json_decode`.

That function is in a separate package called `php-json`. This is wrong on so many levels that I won't talk about it anymore.


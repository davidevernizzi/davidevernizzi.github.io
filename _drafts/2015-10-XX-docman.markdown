---
layout: post
title:  "Docman"
date:   2015-10-DD
categories: docman
---

One day I had to send a customer the documentation of an API I did for him.
Now, if you have to develop and test a RESTful API, Postman is a super tool. It
allows you to create requests, inspect results, it can sens any HTTP verb,
custom headers, it supports authentication and [much
mode](https://getpostman.com).

However, Postman lacks the capability to generate documentation out of the calls you
wrote within it. Of course, since I had all the test calls organized into
a Postman collection, I looked on the Internet for a tool to convert a Postman
collection into a text file, but I couldn't find one. Appartently, also
(other)[stackoverflow.com/questions/29238120/creating-html-doc-from-postman-collection]
(people)[https://github.com/postmanlabs/postman-app-support/issues/204] had the same problem.

So I decided to write my own documentation exporter. At first I thought about
php, but then, since I was learning react, I decided to make a small webapp for
this task. It took me some 3 hours to achieve a working example: way more than
what it would had took me to copy and paste the calls into a text editor!

While I was on holiday, (someone)[https://github.com/rowasc/docman] forked my
github repo and made some pull request. Aw, the joy of integrating them once
I got back. Thank you very much again @rowasc.

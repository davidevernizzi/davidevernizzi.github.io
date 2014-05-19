---
layout: post
title:  "mysqlimport performance"
date:   2014-03-26 00:05:20
categories: mysql
---


I had to import a very large dataset (about 2.5M rows -- OK, not that large,
but large enough to cut my teeth on it). After a quick search on google I found
out that the most efficient way to import data into mysql is to use
the `mysqlimport` command which is shipped with MySql.

It's amazing how efficient it is. I used it to import `cvs` files into a MySql
server. Bot the source and the destination are hostes on AWS, so the network
time should be small enough. It manages to import aroung 180K rows in less tha
15 seconds.

---
layout: post
title:  "When using create-react-app you can use process.env.PUBLIC_URL to access the public folder"
date:   2020-03-30
tags: []
---

There is no need to eject a react app to serve static files. It is enough to put them in the public folder and the access them by using `process.env.PUBLIC_URL + '/file-to-serve'`.

---
layout: post
title:  "TITLE HERE"
date:   2017-MM-DD
categories: tag
---

I wanted to create a luminus application that uses mongo as DB and that can be run using docker.

1. create a new application
   `lein new luminus arrivals-backend2 +mongodb +cider +swagger +service +kibit`

   Note: I did not use `+war` because I did not want to run it on tomcat

1. write some mongo DB test code
   ```clojure
   TBD
   ```

1. Create a docker-compose.yml file
   ```yaml
    version: '2'

    services:
      java:
        image: java:alpine
        ports:
        - "3000:3000"
        volumes:
        - ./:/mnt
        depends_on:
        - mongo
        environment:
        - DATABASE_URL=mongodb://mongo/arrivals_backend4_dev
        command: java -jar /mnt/arrivals-backend4.jar

      mongo:
        image: mongo:latest
        ports:
        - "27017:27017"

   ```
   a few note are worth here:
   * `DATABASE_URL`
   * `volumes`
   * `command`
   * No Dockerfile



---
layout: post
title:  "Running Luminus microservices using docker compose"
date:   2017-03-15
categories: clojure, luminus, microservices, docker, docker-compose
---

I wanted to create a Luminus application that uses mongo as DB and that can be run using docker.

1. Create a new application

   You can use any profile you want. I used this ones `lein new Luminus arrivals-backend2 +mongodb +cider +swagger +service +kibit`

   Note: I did not use `+war` because I did not want to run it on tomcat

1. Create a docker-compose.yml file

    I'm experimenting with microservices, so in this example I created two different services that both connects to the same mong database hosted on a third container.
    Note that on my 5$/month Amazon Lighsail instance (512 MB Memory, 1 Core Processor) this is the maximums I can allocate before the docker container crash for resources issues.
    I might try to decrease the memory allocated to each container or to enable swapping (by default there is not a swap partition, but since it has an SSD, it may help).

    ```yaml
    version: '2'

    services:
      foo:
        image: java:alpine
        ports:
        - "3000:3000"
        volumes:
        - ./:/mnt
        depends_on:
        - mongo
        environment:
        - DATABASE_URL=mongodb://mongo/foo
        command: java -jar /mnt/foo.jar

      bar:
        image: java:alpine
        ports:
        - "3001:3000"
        volumes:
        - ./:/mnt
        depends_on:
        - mongo
        environment:
        - DATABASE_URL=mongodb://mongo/bar
        command: java -jar /mnt/bar.jar


      mongo:
        image: mongo:latest
        ports:
        - "27017:27017"
    ```

    a few note are worth here:
    * `DATABASE_URL` is an environment variable that is passed to the services and that is consumed by Luminus to configure the database access 
    * `volumes` here is my local directory that is mounted in `/mnt` so that the JARs contained into my local directory can be accessed by the container
    * `command` overrides the default command of the java container and runs the JAR of the service
    * There is no custom Dockerfile for the services. On one side this makes it simpler to maintain the system, but on the other you should keep in mind that any change on the java image will reflect on your system, so you might want to pin the java image version

1. Write some mongo DB test code.

   If no db code is loaded in the JAR, Luminus will not try to connect to the DB, so if you want to try it, you need to add some DB related code. You can do it anywhere in the code. I added it into `src/clj/foo/routes/services.clj` as a simple route.

   ```clojure
   (GET "/all" []
    :return s/Str
    (->>
     (db/get-all-users)
     (map #(dissoc % :_id))
     (map #(generate-string % {:pretty true}))
     (clojure.string/join ", ")
     ok
    )
   )
   ```


---
layout: post
title:  "A Little Docker Journey"
date:   2017-11-06
categories: docker, dev, devops
---

I did my very first semi-seriuos test with docker; so far I'm pretty happy with what I have got. I have a small project, let's call it `superduper`, composed of
- frontned written in React
- backend in Clojure which runs behind Apache Tomcat
- database on MongoDB

I wanted a CI workflow so that each time I push on git, Jenkins creates a new build with a new docker image and uploads everything on a Docker registry.
The Docker registry I'm using is a private Nexus3 instance, but it can be anything. My Jenkins instance has the Docker Pipeline plugin installed.

I have created an overall setup with Docker and Jenkins.
Each project (FE, BE) has `Jenksinfile` and a `Dockerfile`.

The `Jenkinsfile` has the following structure:

```groovy
def version = "1.0.0" // This must be somehow be fetched dynamically OR the Jenkins file must be updated for each new version.
def project = "superduper"

node {
    //Clean Workspace
    //--------------------------------------------------------
    stage "clean workspace"
    deleteDir()

    //Checkout sourcecode
    //--------------------------------------------------------
    stage "checkout"
    checkout scm

    //Unit Tests
    //------------------------------------------------------------
    stage "unit test"

    //Build
    //------------------------------------------------------------
    stage "build"

    // I build inside docker so I do not have to install dependencies on Jenkins. Note that .m2 directory is shared so it is not downloaded each time
    try {
        sh "docker run \
            -w /usr/src/app \
            -v `pwd`:/usr/src/app \
            -v ~/.m2:/home/user/.m2 \
            -e LOCAL_USER_ID=\$UID clojure:lein-2.7.1-alpine /bin/bash \
            -c 'lein with-profile production ring uberwar; chmod -R a+rwx target'" 
            // I need the ugly chmod at the end because of permission issues.
    } catch (e) {
        error("build failed")
    }

    //Tag
    stage "tag git"
    //------------------------------------------------------------
    sh "git tag v${version}"
    sh "git push --tags"

    //Docker stuff
    //--------------------------------------------------------
    stage('Build docker'){
           image = docker.build("${project}:${version}", ".")
           latest = docker.build("${project}:latest", ".")
           docker.withRegistry('https://docker.qaenv.it/', 'Nexus'){
                image.push()
                latest.push()
           }
    }
}
```

The backend `Dockerfile` has the following structure:

```Dockerfile
# Pull from tomcat
FROM tomcat:9.0.1-jre8-alpine

# Connect to localDB (see docker-compose.yml later)
ENV DB_URI mongodb://mongo:27017/superduper

# Copy the build artifact to the tomcat webapps directory
COPY ./target/superduper.war /usr/local/tomcat/webapps

# Expose tomcat port
EXPOSE 8080
```

and frontend one is

```
# Pull from standard apache image
FROM httpd:2.4-alpine

# Inject my local config
# (basically just a virtual host 
# + the httpd.conf that enables virtual hosts)
COPY ./httpd_conf/httpd.conf /usr/local/apache2/conf/
COPY ./httpd_conf/httpd-vhosts.conf /usr/local/apache2/conf/extra/

# Copy code of the frontend into Document Root
COPY ./index.html /usr/local/apache2/htdocs/
COPY ./build /usr/local/apache2/htdocs/

# Export apache port
EXPOSE 80
```

with the following virtual host `httpd-vhost.conf`

```
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/local/apache2/htdocs

    ErrorLog /usr/local/apache2/logs/error.log
    CustomLog /usr/local/apache2/logs/access.log combined

    ProxyPass /api http://tomcat:8080/
    ProxyPassReverse /api http://tomcat:8080/superduper
</VirtualHost>
```

The Jenkins job is confiured to run each time a commit is pushed in git. This creates a new Docker image which is uploaded on Nexus.
The Docker images is tagged both with the build number and as `latest`.

Finally, there is a `docker-compose.yml` that puts everything together:

```
version: "3"

services:
  httpd:
    image: my-registry.com/superduper-frontend:latest
    ports:
    - 80:80

  tomcat:
    image: my-registry.com/superduper-backend:latest
    environment:
      - DB_URI=mongodb://mongo:27017/superduper # this is used by the backend to connect to the DB
    ports:
      - 8080:8080

  mongo:
    image: mongo:3.5.13
    volumes:
      - ./data:/data/db
    ports:
      - 27017:27017
```

Bonus, there are a couple of other docker-compose files for production and development overrides:

```
version: "3"

services:
  mongo:
    volumes:
      - /tmp/data:/data/db
```

```
version: "3"

services:
  httpd:
    volumes:
      - ./frontend:/usr/local/apache2/htdocs/

  tomcat:
    volumes:
      - ./webapp:/usr/local/tomcat/webapps
```

which are run as `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up`.

---
layout: post
title:  "A lLittle Docker Journey"
date:   2017-MM-DD
categories: docker, dev, devops
---

My very first semi seriuos test with docker. I have a small project `superduper` composed of
- frontned written in React
- backend in Clojure which runs behing Apache Tomcat
- DB on MongoDB

I wanted a CI workflow so that each time I push on git, Jenkins creates a new build, a new docker image and uploads everything on a Docker registry.

The Docker registry I'm using is a private Nexus3 instance, but it can be anything. My Jenkins instance has the Docker Pipeline plugin installed.

I have created an overall setup with Docker and Jenkins.

Each project (FE, BE) has `Jenksinfile` and a `Dockerfile`.

The `Jenkinsfile` has the following structure:

```groovy
```

The backend `Dockerfile` has the following structure:

```
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

# Inject my local config (basically just a virtual host + the httpd.conf that enables virtual hosts)
COPY ./httpd_conf/httpd.conf /usr/local/apache2/conf/
COPY ./httpd_conf/httpd-vhosts.conf /usr/local/apache2/conf/extra/

# Copy code of the frontend into Document Root
COPY ./index.html /usr/local/apache2/htdocs/
COPY ./build /usr/local/apache2/htdocs/

# Export apache port
EXPOSE 80
```

and the virtual host `httpd-vhost.conf`

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


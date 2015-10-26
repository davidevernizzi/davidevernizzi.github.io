---
layout: post
title:  "Using docker on AWS ElasticBeanstalk"
date:   2015-MM-DD
categories: docker, AWS, EB
---

OK, (this
guy)[http://blog.flux7.com/blogs/docker/10-steps-deploying-docker-containers-on-elastic-beanstalk] saved my life!
I was trying to put Yii2 on AWS ElasticBeanstalk and I was having huge
problems due to a strange behavior of composer. So I thought it was a good
occasion to start experimenting with docker. Once you know how to do, it is all
very easy, but there a couple of points that are not clear at all in the AWS
documentation.

Here is what I learnt:

* If you use private repository on docker hub, you must create a credential
  file and you must store it on S3. It is all very easy to do:
  
  1. first sign in with docker cli `docker login`
  2. then find your credential file in `~/.docker/config.json`. It should look
     like
     ```json
     {
         "auths": {
             "https://index.docker.io/v1/": {
                 "auth": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                 "email": "davide.vernizzi@gmail.com"
             }
         }
     }
     ```

     as you see docker is smart enough not to store your password, but only an
     authentication token. Very helpful because we can directly upload the file
     on S3 in a bucket. So just upload the file without any modification.
  3. Create a file called `Dockerrun.aws.json` (it must have this exact name)
     and save it


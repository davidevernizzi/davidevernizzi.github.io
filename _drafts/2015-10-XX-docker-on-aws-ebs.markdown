---
layout: post
title:  "Using docker on AWS ElasticBeanstalk"
date:   2015-MM-DD
categories: docker, AWS, EB
---

TL;DR: create this two files `Dockerfile` and `Dockerrun.aws.json`, put them in
a directory and run `eb deploy` for each new version.

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
     on S3 in a bucket (let's say `my_project_bucket`). So just upload the file without any modification.
  3. Create a file called `Dockerrun.aws.json` (it must have this exact name)
     and save it in a directory together with the `Dockerfile` (again, this
     must have this exact name). The `Dockerrun.aws.json` file should look
     something like this:
     ```json
{
    "AWSEBDockerrunVersion": "1",
        "Authentication": {
            "Bucket": "my_project_bucket",
            "Key": "docker_config.json"
        },
        "Image": {
            "Name": "davidevernizzi/my_project_image:latest",
            "Update": "true"
        },
        "Ports": [
        {
            "ContainerPort": "80"
        }
    ]
}
     ```
     (yes, we must specify the ContainerPort params in the `Docker.aws.json`
     too).

* When we finished this, we have everything we need to deploy our image to
  Beanstalk. To deploy, just type `eb deploy`: this will result in an output like
  this:
  ```
  $ eb deploy
  Creating application version archive "app-XXXXXX_XXXXXX".
  Uploading Your_environment_name/app-XXXXXX_XXXXXX.zip to S3. This may take a while.
  Upload Complete.
  INFO: Environment update is starting.                               
  INFO: Deploying new version to instance(s).                         
  INFO: Environment health has transitioned from Ok to Info. Command is executing
  on all instances.
  INFO: Docker container 31ad5321e231 is running aws_beanstalk/current-app.
  INFO: New application version was deployed to running EC2 instances.
  INFO: Environment update completed successfully.                    
                                                                        
  Alert: An update to this CLI is available.
  ```

  meaning that:

  1. the AWS CLI created a zip file containing `Dockerfile` and
     `Dockerrun.run.json` and uploaded it somewhere on S3 (we do not care about
     this detail since is handled by AWS automatically).
  2. the image specified in the `Dockerfile` has been pulled from dockerhub
     (using the authentication token specified in
     `my_project_bucket/docker_config.json`)
  3. the new version has been deployed on ElasticBeanstalk

I still have a number of issues with this process, but it's simple and stable
enough to be used. Next point to discover:

* how to prevent AWS from caching the Dockerfile and force it to perform a git
  pull even if there were no changes to the `Dockerfile`. Currently I run the
  image, make a git pull, commit and push the image for each deploy :-(
* what's the best way to handle environment variables and dev vs. production
  environments.

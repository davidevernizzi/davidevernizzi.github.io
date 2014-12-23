---
layout: post
title:  "AWS Elastic Beanstalk and SugarCRM"
date:   2014-12-23
categories: aws, sugarcrm
---

SugarCRM is an awful piece of software. At least the version I am forced to
use — I guess newer versions are better, but we are stuck with an old version
which is, well, old.

We now are using EBS for production servers which is a very good thing, but
dealing with Sugar is so difficult. In particular we had two problems:

1. Moving the sessions to the database
2. Dealing with studio in production

The first issue was quite easy and I will talk about this later.

The second was not that quick. The problem is that studio makes a lot of
changes on the local file system, but, of course, this brings a lot of issues:
it does not scale since changes are not propagated to the other instance; and
it is not upgrade safe since each time you push a new version in production,
all the changes made with studio are lost.

In principle it should be enough to log on the instance where the changes were
made (not obvious in a highly replicated scenario, but fortunately this was not
the case), make a commit and push the changes back to the repo. 

Unluckily when EBS updates the code it finally removes the .git directory -m
and, therefore, you have not a repo anymore. We solved this latter issue by
copying the .git directory in production, make the commit, push it to the repo
and remove the directory.

Therefore, our workflow with Sugar and EBS is:

* Work as much as possible locally with Vagrant
* Whenever there are changes in production made with studio:

```
local# cd local_sugar_dir
local# scp -r .git ec2-user@ip_of_machine_with_changes:
local# ssh ec2-user@ip_of_machine_with_changes
 
remote# sudo mv .git /var/www/html
remote# cd /var/www/html
remote# git status
remote# sudo git commit -a -m '...'
remote# sudo git format-patch -1 HEAD
 
local# wget ip_of_machine_with_changes/file.patch
 
remote# sudo rm -rf file.patch .git
 
local# git apply --stat file.patch
local# git apply --check file.patch
local# git am < file.patch
local# git push
```

That's all.

---
layout: post
title:  "Switch environments between projects"
date:   2020-01-08
tags: []
---

Working as a fullstack developer sometimes does not help with development environments. Projects, in the era of microservices, tend to be very complex and to have a lot of moving parts (db, multiple microservices, frontend, kafka, ...), and the simplest change involves a number of different components to be updated. Moreover, I usually work on multiple projects in parallel (e.g. current customer, bugfixing on old project, side projects), and switching between projects is a pain. My workflow usually starts from the shell; I'm on MacOS and I use iTerm2 and Visual Studio Code, usually, so the workflow typically is:

- open a bunch of tabs

- go to the root of each subproject (e.g. backend, frontend, multiple microservices)

- run docker in background if necessary (i.e. for the DB)

- run 'code ./' to open the editor

- run the application (e.g. 'npm start')

- open the browser at the right location

- develop

- open the issue tracker/project manager (e.g. Jira)

- open the git repository (e.g. github), usually one per subproject

- open additional software useful for debugging and development (e.g. Postman or Insomnia)

The workflow is tedious and if I need to switch between projects it brings a significant overhead; for some time I have just left everything open, but my computer is only so much capable, and, more importantly, I need to visually clear things between tasks (the feeling of closing 3 editor, a couple of software and tens of tabs open on a few browsers windows is priceless).
Unfortunately manually reopening everything is too slow; it's like switching off the computer each time instead of just suspending it, so I was thinking about scripting it. 

I come up with a personal hack (more on that later), but in the meanwhile I found out that there other possible solutions:
- iTerms2 dynamic profiles (https://banga.github.io/blog/2020/03/02/little-known-features-of-iterm2.html, https://www.iterm2.com/documentation-dynamic-profiles.html)
- Maybe Alfred workflows (https://www.alfredapp.com/workflows/)

## My Hack

Since everything starts (or can be started) from the shell, I ended up using [ttab](https://github.com/mklement0/ttab) and adding a small script to run everything. Of course there must be a better approach, but this one just does its job, so I'm using it since a few weeks and I must say I'm quite happy. It would be great if there was a way of freezing the state of a number of application and resume them at some point (like I would do if everything was inside a virtual machine, just without the overhead), but for the moment it's not there.

So I come up with this hack:

brew install https://raw.githubusercontent.com/mklement0/ttab/master/ttab.rb

brew install shyaml

in `startup.yaml`:
```
services:
    be_ec2:
        description: Backend on EC2 classic
        path: be_ec2
        command: "docker run -d -ti -p 8000:8000 amazon/dynamodb-local; code ./; nvm use system; npm start"
    app:
        description: App with Expo
        path: app
        command: "code ./; nvm use system; npm start"
```

in `makenv.sh`:
```
#!/bin/bash

SERVICES=$(cat startup.yaml | shyaml  get-value services | shyaml keys)

for S in $SERVICES; do
    ttab -d $(cat startup.yaml | shyaml  get-value services.$S.path) "$(cat startup.yaml | shyaml  get-value services.$S.command)"
done
```

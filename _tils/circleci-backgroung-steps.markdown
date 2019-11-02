---
layout: post
title:  "CircleCI has background tasks"
---

CircleCI has the concept of background task. A background task has to be waited, somehow. Found the following snipped to do so:

```yaml
      - run:
          name: Waiting for App server to be ready
          command: |
            for i in `seq 1 10`;
            do
              nc -z localhost 3000 && echo Success && exit 0
              echo -n .
              sleep 1
            done
            echo Failed waiting for App && exit
```

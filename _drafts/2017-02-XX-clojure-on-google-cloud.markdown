---
layout: post
title:  "Deploying Clojure on Google Cloud Platform"
date:   2017-MM-DD
categories: google cloud platform, clojure, mongodb
---

* Easy to setup the system:
    1. Download Google Cloud SDK
    2. run `install.sh` which basically add it to the path
    3. add the file `appengine-web.xml` to the `WEB-INF` directory of the war.
       This can be done automatically by putting the file into the directory `war-resources`
       under the root directory of the project. The file should contain something like:
       ```xml
       <appengine-web-app xmlns="http://appengine.google.com/ns/1.0">
          <application>airbnb-checklist</application>
          <version>1</version>
          <threadsafe>false</threadsafe>
       </appengine-web-app>
       ```
       where `application` should be set to the name of your GCP application.
    4. build with classic `lein uberjar`, then unzip the was file into a directory and run `dev_appserver.py` over that directory.
       This one-liner does the trick:
       ```sh
       lein uberwar && rm -rf gae/* && unzip -d gae/ -q target/uberjar/airbnb-checklist.war && dev_appserver.py gae && dev_appserver.py gae
       ```
       This will create a copy of the remote platform on your machine, available at `localhost:8000`


* `wrap-default` breaks GAE. `dev_appserver.py` will complain saying:
  ```
  java.security.AccessControlException: access denied ("java.lang.RuntimePermission" "modifyThreadGroup")
  ```

* [Check this] MongoDB cannot be used on GCP because it has no threads. `dev_appserver.py` will complain saying:
  ```
  java.security.AccessControlException: access denied ("java.lang.RuntimePermission" "modifyThreadGroup")
  ```

* References

1. Google Cloud SDK: https://cloud.google.com/sdk/docs/quickstart-mac-os-x
2. Google Cloud Dashboard: https://console.cloud.google.com/code/develop/browse/java-gae-quickstart/master?project=airbnb-checklist

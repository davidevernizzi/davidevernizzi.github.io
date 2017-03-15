---
layout: post
title:  "Emacs, luminus and nREPL"
date:   2017-01-27
categories: clojure, nrepl, emacs, luminus, distilled tutorial
---

1. Create a new project with luminus (optional)

   ``` lein new luminus foobar ```

2. Setup nREPL in Luminus

   In order to run the remote nREPL, just define the `NREPL_PORT` environment variable and run the project. I compiled the project (`lein uberjar`) and directly run as a jar. It should also work from Tomcat

   ```
   export NREPL_PORT=7000
   java -jar target/uberjar/foobar.jar
   ```

3. Connect remotely

   To connect to the remote nREPL

   ```
   lein repl :connect 7000
   ```

4. Inject code

   From the repl you just launched (the one with `:connect 7000`), you can inject new code into the jar. Let's say you modified the file `foobar.clj` and you want to test it. Just type `(load-file "foobar.clj")` and the new code should be loaded into the running application

5. Connect from Emacs

   To connect from Emacs to the remote REPL, just `M-x cider-connect` and then specify the host and port (localhost and 7000 in our case). If you followed all the steps, Emacs should complain that 
   If you want to connect from Emacs using Cider, you have to modify a couple of things. If you just tr

   First you need to add the relative plugin `[cider/cider-nrepl "0.15.0-snapshot"]` (actually check that the version matches the emacs one).

6. Emacs shortcuts

   The most useful shortcut is `C-c C-l` which will send the code to the remote REPL and inject it into the running application (just list `load-file` does)

**References**

* http://www.luminusweb.net/docs/deployment.md#enabling_nrepl
* https://www.cheatography.com/bilus/cheat-sheets/emacs-cider/

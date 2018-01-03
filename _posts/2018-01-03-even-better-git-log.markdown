---
layout: post
title:  "A (even) better git log"
date:   2018-01-03
categories: git
---

TL;DR;

```
$ git log --graph --branches --oneline --decorate --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'

$ git config --global alias.lg "log --graph --branches --oneline --decorate --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

$ git lg
```

Recently I have decided to move from SourceTree back to command line git. Don't get me wrong, SourceTree is a great software, but where I work we use a set of scripts to manage git branches
so that concurrent features and versions are correctly related each other and, unfortunately, this is not 100% compatible with SourceTree. So to avoid errors due to using SourceTree instead of
our custom git commands, I have decided to go back to command line. However, after using SourceTree I got used to its visual display of the graph of commits. Fortunately, git has a built-in
mechanisms to show such a graph, the `--graph` flag, usually coupled with `--oneline`.

However, we can do better. I have found a post where it is shown a [better git log](https://coderwall.com/p/euwpig/a-better-git-log). The result is quite okay, but we can still make a
little better. I have found [this](https://stackoverflow.com/questions/1841405/how-can-i-show-the-name-of-branches-in-git-log) StackOverflow answer that suggests to use `--decorate` to achieve
something similar. I still prefer the former version, however the latter has nicely coloured branches.

Before:
![Better git log]({{ site.url }}/images/Better-git-log.png)

After:
![Even better git log]({{ site.url }}/images/Even-better-git-log.png)

After searching a while, I have found that these branches are the decorations printed by `--decoration` and by `%d` in the custom git log. The post used `%C(yellow)%d` to color the decorations in
yellow, but if we use `%C(auto)%d` the decorations will be nicely colored, just as `--decoration` would do.

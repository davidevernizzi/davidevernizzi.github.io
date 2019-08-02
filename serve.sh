#!/bin/sh

# Init rbenv
eval "$(rbenv init -)"

# Build site to get the gallery
bundle exec jekyll serve


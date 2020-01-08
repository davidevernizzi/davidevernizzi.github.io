#!/bin/sh

# Init rbenv
# eval "$(rbenv init -)"

# Build site to get the gallery
# bundle exec jekyll serve

docker run --rm --volume="$PWD:/srv/jekyll" --volume="$PWD/vendor/bundle:/usr/local/bundle" -p 4000:4000 -it jekyll/jekyll:3.8 jekyll serve

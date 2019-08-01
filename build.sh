#!/bin/sh

# Init rbenv
eval "$(rbenv init -)"

# Build site to get the gallery
bundle exec jekyll build

# Copy built gallery. This is needed because GitHub Pages will not allow building in remote
mv pictures pictures.old
cp -r _site/pictures ./

# Git stuff
git add pictures
git commit -a -m $1
git push

# Put original pictures back (not needed?)
#rm -rf pictures
#mv pictures.old pictures

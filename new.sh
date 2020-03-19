#!/bin/bash
# usage bash new.sh title of the new post

DATE=`date +%Y-%m-%d`
FILENAME="$DATE-`echo $* | tr ' ' '-'`.markdown"

cat _templates/post.markdown | sed -e "s/TITLE/$*/g" | sed -e "s/DATE/$DATE/g" > _drafts/$FILENAME

vim _drafts/$FILENAME

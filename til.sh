#!/bin/bash
# usage bash new.sh title of the new post

DATE=`date +%Y-%m-%d`
FILENAME="$DATE-`echo $* | tr ' ' '-'`.markdown"

cat _templates/til.markdown | sed -e "s/TITLE/$*/g" | sed -e "s/DATE/$DATE/g" > _tils/$FILENAME

vim _tils/$FILENAME

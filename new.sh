#!/bin/bash

DATE=`date +%Y-%m-%d`
FILENAME="$DATE-`echo $* | tr ' ' '-'`.markdown"

cat _drafts/template.markdown | sed -e "s/TITLE/$*/g" | sed -e "s/DATE/$DATE/g" > _drafts/$FILENAME

vim _drafts/$FILENAME

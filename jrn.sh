#!/bin/bash
# usage bash jrn.sh

DATE=`date +%Y-%m-%d`
FILENAME="$DATE-`echo $* | tr ' ' '-'`.markdown"

cat _templates/jrnl.markdown | sed -e "s/TITLE/$DATE/g" | sed -e "s/DATE/$DATE/g" > _jrnl/$FILENAME

vim _jrnl/$FILENAME

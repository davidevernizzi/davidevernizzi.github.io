#!/bin/bash
# usage bash jrn.sh

DATE=`date +%Y-%m-%d`
FILENAME="$DATE-`echo $* | tr ' ' '-'`.markdown"

cat _journal/template| sed -e "s/TITLE/$DATE/g" | sed -e "s/DATE/$DATE/g" > _journal/$FILENAME

vim _journal/$FILENAME

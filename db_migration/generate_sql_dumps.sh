#!/usr/bin/env bash

# set up to not require password for mysqldump: http://stackoverflow.com/questions/9293042/mysqldump-without-the-password-prompt
mysqldump -u aml aml category > category.sql --complete-insert --hex-blob
mysqldump -u aml aml agency > agency.sql --complete-insert --hex-blob

# gather images
IMG_DIR=/usr/share/tomcat/images
IMG_DEST=../images
find $IMG_DIR -type f -exec cp {} $IMG_DEST \;

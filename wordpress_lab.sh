#!/bin/bash

# Setup script for Wordpress theme lab
# Author: Gianni Salinetti
# Version: 0.1

wp_img_test=wptest
db_img_name=mysql
wp_cnt_name=wplab
db_cnt_name=wpmysql
db_root_pw=password

### Image build ###
cd test && docker build -t ${wp_img_test} .
if [ $? -ne 0 ]; then
    echo "Error building ${wp_img_test} image"
    exit 1
fi

### Deploy updated application ###

# Stop wp container
if (docker ps | grep ${wp_cnt_name} > /dev/null); then
  echo "Stopping and removing container ${wp_cnt_name}..."
  docker stop ${wp_cnt_name} > /dev/null && docker rm ${wp_cnt_name} > /dev/null
elif (docker ps -a | grep ${wp_cnt_name} > /dev/null); then
  echo "Removing stopped container ${wp_cnt_name}..."
  docker rm ${wp_cnt_name} > /dev/null
fi

# Stop db container
if (docker ps | grep ${db_cnt_name} > /dev/null); then
  echo "Stopping and removing container ${db_cnt_name}..."
  docker stop ${db_cnt_name} > /dev/null && docker rm ${db_cnt_name} > /dev/null
elif (docker ps -a | grep ${db_cnt_name} > /dev/null); then
  echo "Removing stopped container ${db_cnt_name}..."
  docker rm ${db_cnt_name} > /dev/null
fi

# Run mysql container
docker run --name ${db_cnt_name} -e MYSQL_ROOT_PASSWORD=${db_root_pw} -d ${db_img_name}:latest
# Run a new wp instance
docker run --name ${wp_cnt_name} --link ${db_cnt_name}:mysql -p 8080:80 -d ${wp_img_test}:latest



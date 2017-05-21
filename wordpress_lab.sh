#!/bin/bash

# Setup script for Wordpress theme lab
# Author: Gianni Salinetti
# Version: 0.1

img_wp_name=wptest
img_db_name=mysql
cnt_wp_name=wplab
cnt_db_name=wpmysql
db_root_pw=scisciola

# Stop wp container
if (docker ps | grep ${cnt_wp_name} > /dev/null); then
  echo "Stopping and removing container ${cnt_wp_name}..."
  docker stop ${cnt_wp_name} > /dev/null && docker rm ${cnt_wp_name} > /dev/null
elif (docker ps -a | grep ${cnt_wp_name} > /dev/null); then
  echo "Removing stopped container ${cnt_wp_name}..."
  docker rm ${cnt_wp_name} > /dev/null
fi

# Stop db container
if (docker ps | grep ${cnt_db_name} > /dev/null); then
  echo "Stopping and removing container ${cnt_db_name}..."
  docker stop ${cnt_db_name} > /dev/null && docker rm ${cnt_db_name} > /dev/null
elif (docker ps -a | grep ${cnt_db_name} > /dev/null); then
  echo "Removing stopped container ${cnt_db_name}..."
  docker rm ${cnt_db_name} > /dev/null
fi

# Run mysql container
docker run --name ${cnt_db_name} -e MYSQL_ROOT_PASSWORD=${db_root_pw} -d ${img_db_name}:latest
# Run a new wp instance
docker run --name ${cnt_wp_name} --link ${cnt_db_name}:mysql -p 8080:80 -d ${img_wp_name}:latest



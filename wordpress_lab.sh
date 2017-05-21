#!/bin/bash

img_wp_name=wptest
img_db_name=mysql
cnt_wp_name=wplab
cnt_db_name=wpmysql
db_root_pw=scisciola

# Stop wp container
docker stop ${cnt_wp_name} && docker rm ${cnt_wp_name}
# Stop db container
docker stop ${cnt_db_name} && docker rm ${cnt_db_name}

# Run mysql container
docker run --name ${cnt_db_name} -e MYSQL_ROOT_PASSWORD=${db_root_pw} -d ${img_db_name}:latest
# Run a new wp instance
docker run --name ${cnt_wp_name} --link ${cnt_db_name}:mysql -p 8080:80 -d ${img_wp_name}:latest



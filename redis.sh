#!/bin/bash
source ./common.sh
app_name=redis
runtime=redis
version=7
script_dir=$PWD

check_user
app_setup
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validation $? "Edit the /etc/redis.conf file ..."
service 
#!/bin/bash
source ./common.sh
app_name=rabbitmq
script_dir=$PWD

check_user

cp $script_dir/$runtime.conf /etc/systemd/system/
validation $? "Copying repo ...."

rabbitmq-server
app_setup
service

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validation $? "created user and gien permissions"
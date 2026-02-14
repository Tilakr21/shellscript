#!/bin/bash
source ./common.sh
app_name=rabbitmq
runtime=rabbitmq-server
script_dir=$PWD

check_user

cp $script_dir/$app_name.repo /etc/yum.repos.d/
validation $? "Copying repo ...."

app_setup

systemctl enable $runtime &>>$LOG_FILE
validation $? "Enable the $app_name service ...."

systemctl daemon-reload
validation $? "Reloading the daemon ."

systemctl start $runtime 
validation $? "Starting the $runtime Service ."

systemctl restart $runtime
validation $? "Restarting the $runtime Service ..."

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validation $? "created user and gien permissions"
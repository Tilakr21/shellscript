#!/bin/bash
source ./common.sh
app_name=mongod
runtime=mongodb-org

check_user

cp mongo.repo /etc/yum.repos.d/
validation $? "Copying of mongo.repo"

app_setup

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
service
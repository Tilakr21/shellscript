#!/bin/bash
source ./common.sh
app_name=mysqld
runtime=mysql-server

check_user
app_setup
service 

mysql_secure_installation --set-root-pass RoboShop@1
validation $? "Setup root password"
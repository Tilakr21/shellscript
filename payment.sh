#!/bin/bash
source ./common.sh
app_name=payment
runtime=python

check_user

dnf install python3 gcc python3-devel -y &>>$LOG_FILE
validation $? "python installation was..."

user_creation
application
service
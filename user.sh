#!/bin/bash
source ./common.sh
app_name=user
runtime=nodejs
version=20
script_dir=$PWD

check_user
app_setup
user_creation
application
service 
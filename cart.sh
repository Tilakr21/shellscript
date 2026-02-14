#!/bin/bash
source ./common.sh
app_name=cart
runtime=nodejs
version=20
script_dir=$PWD

check_user
app_setup
user_creation
application
service 
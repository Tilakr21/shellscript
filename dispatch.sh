#!/bin/bash
source ./common.sh

app_name=dispatch
runtime=golang
script_dir=$PWD

check_user
app_setup
user_creation
application
service
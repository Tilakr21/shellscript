#!/bin/bash
source ./common.sh

app_name=dispatch
runtime=golang

check_user
app_setup
user_creation
application
service
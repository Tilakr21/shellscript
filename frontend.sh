source ./common.sh
app_name=frontend
runtime=nginx
version=1.24
script_dir=$PWD
echo $script_dir

check_user
app_setup
application
service 
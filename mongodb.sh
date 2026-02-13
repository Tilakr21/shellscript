source ./common.sh

check_user

cp mongo.repo /etc/yum.repos.d/
validation $? "Copying of mongo.repo"

dnf install mongodb-org -y 
validation $? "Installing mongodb"
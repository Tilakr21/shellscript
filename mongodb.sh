source ./common.sh

check_user

cp mongo.repo /etc/yum.repos.d/
validation $? "Copying of mongo.repo"

dnf install mongodb-org -y  &>> $LOG_FILE
validation $? "Installing mongodb"

systemctl enable mongod  &>> LOG_FILE
validation $? "Enable the mongod service ...."
systemctl start mongod 
validation $? "Starting the mongod Service ..."

sed -i sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
systemctl restart mongod
validation $? "Restarting the mongod Service ..."
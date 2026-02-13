source ./common.sh
app_name=catalogue
runtime=nodejs

check_user
node_setup
user_creation
applicaton 
service 

cp mongo.repo /etc/yum.repos.d/
validation $? "Copying the mongo repo was ..."

dnf install mongodb-mongosh -y
validation $? "Installing the mongodb client was ..."

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
   mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js &>> $LOG_FILE
   VALIDATE $? "Loading products was ..."
else 
  echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $Y SKIPPING $N" &>> $LOG_FILE
fi
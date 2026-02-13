source ./common.sh
app_name=catalogue
runtime=nodejs
version=20
MONGODB_HOST=mongodb.tilakrepalle.in
script_dir=$PWD

check_user
app_setup
user_creation
application
service 

cp $script_dir/mongo.repo /etc/yum.repos.d/
validation $? "Copying the mongo repo was ..."

dnf install mongodb-mongosh -y &>> $LOG_FILE
validation $? "Installing the mongodb client was ..."

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
   cd /app
   mongosh --host  $MONGODB_HOST </app/db/master-data.js &>> $LOG_FILE
   validation $? "Loading products was ..."
else 
  echo -e "$(date "+%Y-%m-%d %H:%M:%S") | Products already loaded ... $Y SKIPPING $N" &>> $LOG_FILE
  validation $? "Data is already loaded....$Y SKIPPING $N"
fi
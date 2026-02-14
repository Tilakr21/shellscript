#!/bin/bash
source ./common.sh
app_name=shipping
runtime=maven
script_dir=$PWD
MYSQL_HOST=mysql.tilakrepalle.in

check_user
app_setup
user_creation
application

dnf install mysql -y  &>> $LOG_FILE
validation $? "Installing the mysql client was ..."

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE

if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    validation $? "Loaded data into MySQL"
else
    echo -e "data is already loaded ... $Y SKIPPING $N"
    validation $? "data is already loaded ... $Y SKIPPING $N"
fi

service
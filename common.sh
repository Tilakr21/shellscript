user=$(id -u)
LOG_DIR="/var/log/mongo"
LOG_FILE="$LOG_DIR/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_user(){
    if [ $user -eq 0 ]; then
       mkdir -p $LOG_DIR
       echo -e "Executing the script through root user...." | tee -a $LOG_FILE
    else
      echo -e "Need the root access for executing the script..."
      exit 1
    fi
}

validation(){
    if [ $1 -eq 0 ]; then
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $G sucess $N" | tee -a $LOG_FILE
    else 
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $R Failure $N" | tee -a $LOG_FILE
      exit 1
    fi
}

node_setup(){
   dnf module disable $runtime -y &>> $LOG_FILE
   validation $? "Disable the default $runtime version ...."
   
   dnf module enable $runtime:20 -y &>> $LOG_FILE
   validation $? "Enable the $runtime version 20 ...."
   
   dnf install $runtime -y &>> $LOG_FILE
   validation $? "Installing $runtime version 20 was ...."
}

user_creation(){
    # creating system user
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        VALIDATE $? "Creating system user"
    else
        echo -e "Roboshop user already exist ... $Y SKIPPING $N"
    fi
}

application(){
    # downloading the app
    mkdir -p /app 
    VALIDATE $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
    VALIDATE $? "Downloading $app_name code"

    cd /app
    VALIDATE $? "Moving to app directory"

    rm -rf /app/*
    VALIDATE $? "Removing existing code"

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "Uzip $app_name code"
}

service(){
    cp $app_name.service /etc/systemd/system/
    validation $? "Copying the $app_name server is ..."
    
    systemctl daemon-reload
    validation $? "Reloading the daemon ..."
    
    systemctl enable $app_name
    validation $? "Enable $app_name server..."
    
    systemctl start $app_name
    validation $? "Start the $app_name server"
}
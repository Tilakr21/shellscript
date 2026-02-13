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
   dnf module disable $1 -y &>> $LOG_FILE
   validation $? "Disable the default $1 version ...."
   
   dnf module enable $1:20 -y &>> $LOG_FILE
   validation $? "Enable the $1 version 20 ...."
   
   dnf install $1 -y &>> $LOG_FILE
   validation $? "Installing $1 version 20 was ...."
}

user_creation(){
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    validation $? "Creating the user roboshop was ...."
}

applicaton(){
    mkdir -p /app
    count=$(ls -ltr app |wc -l)
    if [ count -le 1 ]; then
      curl -o /tmp/$1.zip https://roboshop-artifacts.s3.amazonaws.com/$1-v3.zip 
      cd /app 
      unzip /tmp/$1.zip
      validation $? "Unzipping $1 was ..." 
      npm install 
      validation $? "Installing of npm was ..."
    else 
      cd /app
      rm -rf *
      validation $1 "Removing the file was..."
      curl -o /tmp/$1.zip https://roboshop-artifacts.s3.amazonaws.com/$1-v3.zip  
      cd /app 
      unzip /tmp/$1.zip 
      validation $? "Unzipping $1 was ..." 
      npm install 
      validation $? "Installing of npm was ..."
    fi 
}

service(){
    cp $1.service /etc/systemd/system/
    validation $? "Copying the $1 server is ..."
    
    systemctl daemon-reload
    validation $? "Reloading the daemon ..."
    
    systemctl enable $1 
    validation $? "Enable $1 server..."
    
    systemctl start $1
    validation $? "Start the $1 server"
}
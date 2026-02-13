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

app_setup(){
   dnf module disable $runtime -y &>> $LOG_FILE
   validation $? "Disable the default $runtime version ...."
   
   dnf module enable $runtime:$version -y &>> $LOG_FILE
   validation $? "Enable the $runtime version $version ...."
   
   dnf install $runtime -y &>> $LOG_FILE
   validation $? "Installing $runtime version $version was ...."
}

user_creation(){
    # creating system user
    id roboshop &>>$LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
        validation $? "Creating system user"
    else
        echo -e "Roboshop user already exist ... $Y SKIPPING $N"
    fi
}

node(){
    cd /app 
    npm install 
}

application(){
    
    if [[ "$app_name" == "frontend" ]]; then
       #downloading the frontend
       rm -rf /usr/share/nginx/html/* 
       validation $? "Removing existing code"

       curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip
       validation $? "Downloaded $app_name code"

       cd /usr/share/nginx/html 
       unzip /tmp/$app_name.zip 
       validation $? "Uzip $app_name code"

    else
     # downloading the app
     mkdir -p /app 
     validation $? "Creating app directory"
 
     curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
     validation $? "Downloaded $app_name code"
 
     cd /app
     validation $? "Moving to app directory"
 
     rm -rf /app/*
     validation $? "Removing existing code"
 
     unzip /tmp/$app_name.zip &>>$LOG_FILE
     validation $? "Uzip $app_name code"
     $runtime
    fi 
}

service(){
    if [ [ "$app_name" == "frontend" ]]; then 
       
       cp $script_dir/$runtime.conf /etc/systemd/system/
       validation $? "Copying the $app_name server is ..."

       systemctl daemon-reload
       validation $? "Reloading the daemon ..."
       
       systemctl enable $runtime
       validation $? "Enable $runtime server..."
       
       systemctl start $runtime
       validation $? "Start the $runtime server"
    else 

      cp $script_dir/$app_name.service /etc/systemd/system/
      validation $? "Copying the $app_name server is ..."
      
      systemctl daemon-reload
      validation $? "Reloading the daemon ..."
      
      systemctl enable $app_name
      validation $? "Enable $app_name server..."
      
      systemctl start $app_name
      validation $? "Start the $app_name server"
    
    fi
}
user=$(id -u)
LOG_DIR="/var/log/mongo"
LOG_FILE="$LOG_DIR/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOG_DIR

check_user(){
    if [ $user -eq 0 ]; then
       echo -e "Executing the script through root user...." | tee -a $LOG_FILE
    else
      echo -e "Need the root access for executing the script..." | tee -a $LOG_FILE
      exit 1
    fi
}


validation(){
    if [ $1 -eq 0 ]; then
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $G sucess" | tee -a $LOG_FILE
    else 
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $R Failure" | tee -a $LOG_FILE
      exit 1
    fi
}
user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_user(){
    if [ $user -eq 0 ]; then
       echo -e "Executing the script through root user...."
    else
      echo -e "Need the root access for executing the script..."
    fi
}


validation(){
    if [ $1 -eq 0 ]; then
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $G sucess"
    else 
      echo -e "$(date "+%Y-%m-%d %H:%M:%S") $2 .... $R Failure"
    fi
}
user=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

validation(){
    if [ $1 -eq 0 ]; then
      echo -e "date +%Y-%M-%D $2 .... $G sucess"
    else 
      echo -e "date +%Y-%M-%D $2 .... $R Failure"
    fi
}

if [ $user -eq 0 ]; then
   cp mongo.repo /etc/yum.repos.d/
   validation $? "Copying of mongo.repo"
   dnf install mongodb-org -y 
   validation $? "Installing mongodb"
   systemctl enable mongod 
   systemctl start mongod 
   systemctl restart mongod
else
   echo "Run the script through root user...."
fi
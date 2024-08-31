#!/bin/bash

Userid=$(id -u)
Logs_folder="/var/log/expense"
Script_name=$(echo $0 | cut -d "." -f1) #$0 --refers current script name
Time_stamp=$(date +%Y-%m-%d-%-H-%M-%S)
Log_file="$Logs_folder/$Script_name-$Time_stamp.log"

mkdir -p $Logs_folder  # -P refers to know the folder is already created or not

echo "The script starts at $(date)" | tee -a $Log_file



Validate(){
    if [ $1 -eq 0 ]
    then
        echo "$2 is success" | tee -a $Log_file
    else
        echo "$2 is not success" | tee -a $Log_file
        exit $1
    fi
}
Check_root(){
    if [ $Userid -ne 0 ]
    then
        echo "please run the script with root previllages" | tee -a $Log_file
        exit 1
    fi 
}
Check_root | tee -a $Log_file

dnf install mysql-server -y | tee -a $Log_file
Validate $? "Installing Mysql server" 

systemctl enable mysqld | tee -a $Log_file
Validate $? "Enabled is " 

systemctl start mysqld | tee -a $Log_file
Validate $? "started Mysql server" 

mysql_secure_installation --set-root-pass ExpenseApp@1 | tee -a $Log_file
Validate $? "Password setting " 

#mysql | tee -a $Log_file
#Validate $? "Mysql installation" | tee -a $Log_file









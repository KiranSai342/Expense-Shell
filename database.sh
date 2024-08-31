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
Check_root 

dnf install mysql-server -y
Validate $? "Installing Mysql server" | tee -a $Log_file

systemctl enable mysqld
Validate $? "Enabled is " | tee -a $Log_file

systemctl start mysqld
Validate $? "started Mysql server" | tee -a $Log_file

mysql_secure_installation --set-root-pass ExpenseApp@1
Validate $? "Password setting " | tee -a $Log_file

mysql
Validate $? "Mysql installation" | tee -a $Log_file

show databases;
Validate $? "Fetching databases" | tee -a $Log_file







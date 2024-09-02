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

dnf module disable nodejs -y &>>$Log_file
Validate $? "Disable default module versions of NodeJS" | tee -a $Log_file

dnf module enable nodejs:20 -y &>>$Log_file
Validate $? "Enabled 20 version of node JS" | tee -a $Log_file

dnf install nodejs -y &>>$Log_file
Validate $? "Installation of NodeJs 20 version" | tee -a $Log_file




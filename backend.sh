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

id expense
if [ $? -ne 0 ]
then
    echo "User is not created.. Creating now" | tee -a $Log_file
    useradd expense &>>$Log_file
    Validate $? "Creating Expense User" |tee -a $Log_file
else
    echo "User already created" | tee -a $Log_file
fi

mkdir -p /app &>>$Log_file
Validate $? "creating directory ..."

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Log_file
Validate $? "Downloading backend code"

cd /app

rm -rf /app/* #Remove the existing code
unzip /tmp/backend.zip &>>$Log_file
Validate $? "Extracting backend code"

npm install &>>$Log_file

cp /home/ec2-user/Expense-Shell/backend.service /etc/systemd/system/backend.service

#Load the data before running backend

dnf install mysql -y &>>$Log_file
Validate $? "Mysql client "

mysql -h  -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$Log_file
Validate $? "Schema loading"

systemctl daemon-reload &>>$Log_file
Validate $? "Daemon-reload "

systemctl enable backend &>>$Log_file
Validate $? "Enabled backend"

systemctl restart backend &>>$Log_file
Validate $? "Restart backend"















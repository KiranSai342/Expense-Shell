#!bin/bash

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

dnf install nginx -y &>>$Log_file
Validate $? "nginx Installation"

systemctl enable nginx &>>$Log_file
Validate $? "Enabled nginx"

systemctl start nginx &>>$Log_file
Validate $? "start nginx"

rm -rf /usr/share/nginx/html/* &>>$Log_file
Validate $? "Removing Default Content of Website"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Log_file
Validate $? "Download Frontend Code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$Log_file
Validate $? "Extracting the code"

cp /home/ec2-user/Expense-Shell/expense.config /etc/nginx/default.d/expense.conf

systemctl restart nginx &>>$Log_file
Validate $? "Restrast the nginx"







#!/bin/bash

Source_Dir=/home/ece2-user/log

if [ -d $Source_Dir ]
then 
    echo " $Source_Dir Exists "
else
    echo " $Source_Dir not Exists"
fi

Files=$(find $Source_Dir -name "*.log" -mtime +14)

echo "Files:$Files"

while IFS= read -r line # IFS = Internal field seperator, empty it will ignore while space.-r is for not to ignore special charecters like /
do 
    echo "Deleting line : $line"
    rm -rf $line
done <<< $Files
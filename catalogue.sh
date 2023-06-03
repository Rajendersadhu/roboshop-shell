source common.sh
component=catalogue


echo -e "${color} configuring nodejs repos ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

echo -e "${color} installing nodejs ${nocolor}"
yum install nodejs -y &>>$log_file

echo -e "${color} Add application User ${nocolor}"
useradd roboshop &>>$log_file
echo -e "${color} create application directory ${nocolor}"
rm -rf ${app_path} &>>$log_file
mkdir ${app_path} &>>$log_file

echo -e "${color} Download the application code ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
cd ${app_path} &>>$log_file

echo -e "${color} extracting the application ${nocolor}"
unzip /tmp/$component.zip &>>$log_file
cd ${app_path} &>>$log_file

echo -e "${color} download the dependencies ${nocolor}"
npm install &>>$log_file

echo -e "${color} Setup SystemD Catalogue Service ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file

echo -e "${color} start catalogue service ${nocolor}"
systemctl daemon-reload &>>$log_file
systemctl enable$component &>>$log_file
systemctl start $component &>>$log_file

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

echo -e "${color} install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>$log_file

echo -e "${color} Load Schema ${nocolor}"
mongo --host mongodb-dev.sraji73.store </app/schema/$component.js &>>$log_file




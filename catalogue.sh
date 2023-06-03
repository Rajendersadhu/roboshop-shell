component=catalogue
color="\e[33m"
nocolor="\e[0m"


echo -e "${color} configuring nodejs repos ${nocolor}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "${color} installing nodejs ${nocolor}"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "${color} Add application User ${nocolor}"
useradd roboshop &>>/tmp/roboshop.log
echo -e "${color} create application directory ${nocolor}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "${color} Download the application code ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "${color} extracting the application ${nocolor}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "${color} download the dependencies ${nocolor}"
npm install &>>/tmp/roboshop.log

echo -e "${color} Setup SystemD Catalogue Service ${nocolor}"
cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>/tmp/roboshop.log

echo -e "${color} start catalogue service ${nocolor}"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable$component &>>/tmp/roboshop.log
systemctl start $component &>>/tmp/roboshop.log

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "${color} install mongodb client ${nocolor}"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "${color} Load Schema ${nocolor}"
mongo --host mongodb-dev.sraji73.store </app/schema/$component.js &>>/tmp/roboshop.log




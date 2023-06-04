

source common.sh
echo -e "${color} copy mongoDB repo file ${nocolor}"
 cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/monodb.repo &>>/tmp/roboshop.log
   stat_check $?

 echo -e "${color} installing mongoDB server ${nocolor}"
yum install mongodb-org -y &>>/tmp/roboshop.log
  stat_check $?

echo -e "${color} update mongodb listen address ${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
  stat_check $?

echo -e "${color} start mongoDB service ${nocolor}"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log
  stat_check $?




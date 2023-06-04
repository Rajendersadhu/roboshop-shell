
source common.sh
echo -e "${color} disable MySQL 8 version ${nocolor}"
yum module disable mysql -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Setup the MySQL5.7 repo file ${nocolor}"
cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Install MySQL Server ${nocolor}"
yum install mysql-community-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color} Start MySQL Service ${nocolor}"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}  change the default root password ${nocolor}"
mysql_secure_installation --set-root-pass roboshop@1 &>>/tmp/roboshop.log
stat_check $?




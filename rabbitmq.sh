


source common.sh
component=$component

echo -e "${color}configure erlang repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/$component/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}configure $component repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/$component/$component-server/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Install $component ${nocolor}"
yum install $component-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Start $component Service ${nocolor}"
systemctl enable $component-server &>>/tmp/roboshop.log
systemctl start $component-server &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}add $component application user ${nocolor}"
$componentctl add_user roboshop $1 &>>/tmp/roboshop.log
$componentctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
stat_check $?







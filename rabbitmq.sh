


source common.sh
echo -e "${color}configure erlang repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}configure rabbitmq repos ${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Install RabbitMQ ${nocolor}"
yum install rabbitmq-server -y &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}Start RabbitMQ Service ${nocolor}"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log
stat_check $?

echo -e "${color}add rabbitmq application user ${nocolor}"
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log
stat_check $?




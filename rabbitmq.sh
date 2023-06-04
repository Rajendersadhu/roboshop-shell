echo -e "\e[33mconfigure erlang repos\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[33mconfigure rabbitmq repos\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstall RabbitMQ\e[0m"
yum install rabbitmq-server -y &>>/tmp/roboshop.log

echo -e "\e[33mStart RabbitMQ Service\e[0m"
systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log

echo -e "\e[33madd rabbitmq application user\e[0m"
rabbitmqctl add_user roboshop $1 &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log


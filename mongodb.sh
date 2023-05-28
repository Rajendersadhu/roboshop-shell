echo -e "\e[33mcopy mongoDB repo file\e[0m"
 cp mongodb.repo /etc/yum.repos.d/monodb.repo &>>/tmp/roboshop.log
 echo -e "\e[33minstalling mongoDB server\e[0m"
yum install mongodb-org -y &>>/tmp/roboshop.log


## modify the config file
echo -e "\e[33mstart mongoDB service\e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log


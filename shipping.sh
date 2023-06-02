echo -e "\e[33minstall maven\e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33msetup an app directory\e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload the application code\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log


echo -e "\e[33mextracting the application\e[0m"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33mdownload the dependencies\e[0m"
cd /app &>>/tmp/roboshop.log
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD Shipping Service\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[33mLoad the service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mStart the service\e[0m"
systemctl enable shipping &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log

echo -e "\e[33minstall mysql client\e[0m"
yum install mysql -y &>>/tmp/roboshop.log

echo -e "\e[33mLoad Schema\e[0m"
mysql -h mysql-dev.sraji73.store -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[33mrestarting this service\e[0m"
systemctl restart shipping &>>/tmp/roboshop.log




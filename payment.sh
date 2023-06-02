echo -e "\e[33minstall python\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33msetup an app directory\e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload the application content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[33mextract the application\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[33mdownload the dependencies\e[0m"
cd /app &>>/tmp/roboshop.log
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD Payment Service\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>>/tmp/roboshop.log


echo -e "\e[33mLoad payment service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
echo -e "\e[33mStart payment service\e[0m"
systemctl enable payment &>>/tmp/roboshop.log
systemctl start payment &>>/tmp/roboshop.log
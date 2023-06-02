echo -e "\e[33mInstall GoLang\e[0m"
yum install golang -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd application Use\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33msetup an app directory\e[0m"
mkdir /app &>>/tmp/roboshop.log


echo -e "\e[33mDownload the application content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log


echo -e "\e[33mextracting the application\e[0m"
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[33mdownload dispatch dependencies\e[0m"
cd /app &>>/tmp/roboshop.log
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

echo -e "\e[33mSetup SystemD dispatch Service\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

echo -e "\e[33mLoad dispatch service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[33mstart dispatch service\e[0m"
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl start dispatch &>>/tmp/roboshop.log


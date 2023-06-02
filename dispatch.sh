echo -e "\e[33mInstall GoLang\e[0m"
yum install golang -y

echo -e "\e[33mAdd application Use\e[0m"
useradd roboshop

echo -e "\e[33msetup an app directory\e[0m"
mkdir /app


echo -e "\e[33mDownload the application content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app


echo -e "\e[33mextracting the application\e[0m"
unzip /tmp/dispatch.zip

echo -e "\e[33mdownload dispatch dependencies\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[33mSetup SystemD dispatch Service\e[0m"
cp /home/centos/roboshop-shell/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[33mLoad dispatch service\e[0m"
systemctl daemon-reload

echo -e "\e[33mstart dispatch service\e[0m"
systemctl enable dispatch
systemctl start dispatch


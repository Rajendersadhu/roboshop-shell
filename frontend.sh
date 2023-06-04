

source common.sh
echo -e "\e[33minstalling nginx server\e[0m"
yum install nginx -y &>>/tmp/roboshop.log
  stat_check $?

echo -e "\e[33mremove the old app content\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log
  stat_check $?

echo -e "\e[33mdownload the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log
  stat_check $?

echo -e "\e[33mextract the frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log
  stat_check $?

echo -e "\e[33mupdate frontend configuration\e[0m"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
  stat_check $?

echo -e "\e[33mstart nginx server\e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl restart nginx &>>/tmp/roboshop.log
  stat_check $?







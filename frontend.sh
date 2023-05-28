echo -e "\e[33minstalling nginx server\e[0m"
yum install nginx -y
echo -e "\e[33mremove the old app content\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[33mdownload the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[33mextract the frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
## we need to copy config file
systemctl enable nginx
echo -e "\e[33mstart nginx server\e[0m"
systemctl restart nginx


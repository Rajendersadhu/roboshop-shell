
color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo script should be running with sudo
  exit 1
fi

app_path="/app"

stat_check() {
     if [ $1 -eq 0 ]; then
        echo SUCCESS
     else
        echo FAILURE
        exit 1
     fi
}

app_presetup() {
  echo -e "${color} Add application User ${nocolor}"

  id roboshop &>>$log_file
  if [ $? -eq 1 ]; then
  useradd roboshop &>>$log_file
  fi

  stat_check $?

  echo -e "${color} create application directory ${nocolor}"
  rm -rf ${app_path} &>>$log_file
  mkdir ${app_path} &>>$log_file

  stat_check $?

  echo -e "${color} Download the application code ${nocolor}"
  curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
  cd ${app_path} &>>$log_file

  stat_check $?

  echo -e "${color} extracting the application ${nocolor}"
  cd ${app_path} &>>$log_file
  unzip /tmp/$component.zip &>>$log_file

  stat_check $?

}
systemd_setup() {
  echo -e "${color} Setup SystemD $component Service ${nocolor}"
  cp /home/centos/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file
  sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /home/centos/roboshop-shell/$component.service
  stat_check $?

  echo -e "${color} Start the service ${nocolor}"
  systemctl enable $component &>>$log_file
  systemctl start $component &>>$log_file

  stat_check $?

}
nodejs() {
  echo -e "${color} configuring nodejs repos ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  stat_check $?

  echo -e "${color} installing nodejs ${nocolor}"
  yum install nodejs -y &>>$log_file
  stat_check $?

  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  npm install &>>$log_file
  stat_check $?

  systemd_setup


}

mongo_schema_setup() {
  echo -e "${color} copy mongodb repo file ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  stat_check $?

  echo -e "${color} install mongodb client ${nocolor}"
  yum install mongodb-org-shell -y &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mongo --host mongodb-dev.sraji73.store </app/schema/$component.js &>>$log_file
  stat_check $?

}

mysql_schema_setup() {
  echo -e "${color} install mysql client ${nocolor}"
  yum install mysql -y &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mysql -h mysql-dev.sraji73.store -uroot -pRoboshop@1 < ${app_path}/schema/$component.sql &>>$log_file
  stat_check $?

}

maven() {
  echo -e "${color} install maven ${nocolor}"
  yum install maven -y &>>$log_file
  stat_check $?

  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  cd ${app_path} &>>$log_file
  mvn clean package &>>$log_file
  mv target/$component-1.0.jar $component.jar &>>$log_file
  stat_check $?


  mysql_schema_setup

  systemd_setup


}

python () {

  echo -e "${color} install python ${nocolor}"
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  stat_check $?
  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  cd /app &>>/tmp/roboshop.log
  pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

  stat_check $?

  systemd_setup

}

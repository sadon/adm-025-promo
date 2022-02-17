#!/bin/bash
sudo yum update -y
sudo yum install mc -y
# Mysql
sudo yum install mariadb-server -y
sudo systemctl start mariadb.service

sudo mysql -e "CREATE DATABASE ${db_name};"
sudo mysql -e "CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_pass}';"
sudo mysql -e "GRANT ALL ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_pass}';"
sudo mysql -e "FLUSH PRIVILEGES;"

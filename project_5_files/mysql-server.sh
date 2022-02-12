#!/bin/bash

## mysql-server
# Set hostname, update OS and install mysql-server
sudo hostnamectl set-hostname mysql-server
bash
sudo apt update
sudo apt install mysql-server -y


# Secure MySql
# This line can be used - sudo mysql_secure_installation

# Alternatively the following can be used -Ubuntu\Debian specific(credits: https://gist.github.com/Mins/4602864):
sudo apt install debconf-utils -y
PASS_MYSQL_ROOT=`openssl rand -base64 12` # Save this password

# Set password with `debconf-set-selections` You don't have to enter it in prompt
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${PASS_MYSQL_ROOT}" # new password for the MySQL root user
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${PASS_MYSQL_ROOT}" # repeat password for the MySQL root user
# Other Code.....
sudo mysql --user=root --password=${PASS_MYSQL_ROOT} << EOFMYSQLSECURE
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOFMYSQLSECURE

# Note down this password. Else you will lose it and you may have to reset the admin password in mySQL
echo -e "SUCCESS! MySQL password is: ${PASS_MYSQL_ROOT}" 

# Check mysql status
systemctl status mysql

# Replace mysql bind address
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart mysql server
systemctl restart mysql

# Create a DB and DB User
sudo mysql
CREATE DATABASE `example_database`;
CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'CaTChMeIfUKhan';
GRANT ALL ON example_database.* TO 'example_user'@'%';
#! /bin/bash
#LAMP Implementation on Ubuntu 20.04
#
#Copyright 2022 Olawale 
#



#update a list of packages in package manager
sudo apt update

#run apache2 package installation
sudo apt install apache2 -y

#Verify apache2 was installed successfully
sudo systemctl status apache2

#Verify using curl
curl http://localhost:80

#Install mysql
sudo apt install mysql-server -y


sudo mysql_secure_installation
#Pass: HP2Cn/r3OtXkpaNi

#Alternatively the following can be used -Ubuntu\Debian specific(credits: https://gist.github.com/Mins/4602864):
sudo apt install debconf-utils
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



#Access the mysql db
sudo mysql

#verify defaults
show databases;

exit



#Install PHP
sudo apt -y install php libapache2-mod-php php-mysql

php -v

#Create a Virtual Host
sudo mkdir /var/www/projectlamp
sudo chown -R $USER:$USER /var/www/projectlamp
sudo vi /etc/apache2/sites-available/projectlamp.conf
<VirtualHost *:80>
    ServerName projectlamp
    ServerAlias www.projectlamp 
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/projectlamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
sudo ls /etc/apache2/sites-available

#Enable the VirtualHost
sudo a2ensite projectlamp
sudo a2dissite 000-default
sudo apache2ctl configtest
sudo systemctl reload apache2
sudo echo 'Hello LAMP from hostname' $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) 'with public IP' $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) > /var/www/projectlamp/index.html

#Update the index.html file with details of the server IP and DNS
cat /var/www/projectlamp/index.html
Hello LAMP from hostname ec2-54-163-3-214.compute-1.amazonaws.com with public IP 54.163.3.214

#Modify Apache precedence for php files
cat /etc/apache2/mods-enabled/dir.conf
<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

#create index.php
cat /var/www/projectlamp/index.php
<?php
phpinfo();
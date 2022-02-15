sudo yum update -y
sudo yum install gdisk -y

sudo vgcreate webdata-vg /dev/xvdb1 /dev/xvdc1 /dev/xvdd1

sudo yum install lvm2

sudo lvmdiskscan

sudo lvcreate -n apps-lv -L 10G webdata-vg

sudo lvcreate -n logs-lv -L 10G webdata-vg

sudo lvs

sudo vgdisplay -v #view complete setup - VG, PV, and LV
sudo lsblk 


sudo mkfs -t ext4 /dev/webdata-vg/apps-lv
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv

sudo mkdir -p /var/www/html

sudo mkdir -p /home/recovery/logs
sudo mount /dev/webdata-vg/apps-lv /var/www/html/
sudo rsync -av /var/log/. /home/recovery/logs/
sudo mount /dev/webdata-vg/logs-lv /var/log


sudo rsync -av /home/recovery/logs/. /var/log

sudo blkid
sudo vi /etc/fstab

sudo mount -a
sudo systemctl daemon-reload


#DB-Server
sudo yum update -y
sudo su
lsblk
gdisk /dev/xvdb
gdisk /dev/xvdc
gdisk /dev/xvdd

sudo vgcreate db-vg /dev/xvdb1 /dev/xvdc1 /dev/xvdd1
sudo lvcreate -n db-lv -L 10G db-vg

sudo mkfs -t ext4 /dev/db-vg/db-lv

sudo lvcreate -n logs-lv -L 10G db-vg
sudo mkfs -t ext4 /dev/db-vg/logs-lv

sudo mkdir -p /home/recovery/logs
sudo rsync -av /var/log/. /home/recovery/logs/
sudo mount /dev/db-vg/logs-lv /var/log


sudo rsync -av /home/recovery/logs/. /var/log

sudo vi /etc/fstab
sudo mount -a
df -h


#Install webserver
sudo yum -y update
sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json
sudo systemctl enable httpd
sudo systemctl start httpd


#Php and dependencies
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum -y install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm



sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo yum module list php
sudo yum module reset php
sudo yum module enable php:remi-7.4
sudo yum install php php-opcache php-gd php-curl php-mysqlnd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm
setsebool -P httpd_execmem 1


https://blog.remirepo.net/post/2019/12/03/Install-PHP-7.4-on-CentOS-RHEL-or-Fedora

wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm

sudo yum -y install php php-opcache php-gd php-curl php-mysqlnd

mkdir wordpress
cd   wordpress
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo rm -rf latest.tar.gz

mkdir wordpress
  cd   wordpress
cp wordpress/wp-config-sample.php wordpress/wp-config.php
cp -R wordpress /var/www/html/
sudo chown -R apache:apache /var/www/html/wordpress
  sudo chcon -t httpd_sys_rw_content_t /var/www/html/wordpress -R
  sudo setsebool -P httpd_can_network_connect=1


sudo yum update
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum -y localinstall mysql57-community-release-el7-11.noarch.rpm 
sudo yum -y install mysql-community-server
systemctl start mysqld.service
sudo systemctl restart mysqld
sudo systemctl enable mysqld



sudo yum -y install https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm

sudo amazon-linux-extras install epel -y
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum -y install mysql-community-server
sudo systemctl enable --now mysqld
sudo grep 'temporary password' /var/log/mysqld.log
2wwt>5#S6-2s

sudo mysql_secure_installation -p'2wwt>5#S6-2s'

4eCadP3YW&AfX67


mysql -u root -p
CREATE DATABASE wordpress;
CREATE USER `myuser`@`172.31.18.19` IDENTIFIED BY 'uBf5H4F@kx4tsTM';
ALTER USER `myuser`@`172.31.18.19` IDENTIFIED WITH mysql_native_password  BY 'uBf5H4F@kx4tsTM';

CREATE USER `admin`@`172.31.18.19`IDENTIFIED WITH mysql_native_password  BY 'uBf5H4F@kx4tsTM';

GRANT ALL ON wordpress.* TO 'admin'@'172.31.18.19';
FLUSH PRIVILEGES;
SHOW DATABASES;
exit


sudo yum -y install mysql
sudo mysql -u admin -p -h 172.31.32.123


SELECT user,authentication_string,plugin,host FROM mysql.user;


valentine
7PcxQY0h0xaWCRbdhN


// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'myuser' );

/** Database password */
define( 'DB_PASSWORD', 'uBf5H4F@kx4tsTM' );

/** Database hostname */
define( 'DB_HOST', '172.31.32.123' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );
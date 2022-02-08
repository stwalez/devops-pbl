# Project 1

## Lamp Stack Implementation
---
### Step 1 - Installing Apache and Updating Firewall

Update a list of packages in package manager
- `sudo apt update`

Run apache2 package installation
- `sudo apt install apache2 -y`

Verify apache2 was installed successfully
- `sudo systemctl status apache2`

Verify using curl
- `curl http://localhost:80`
![apache2_curl.png](screenshots/apache2_curl.png "apache curl")

Set Security Group:
![apache2_curl_pub_ip.png](screenshots/sec_groups.png)

Curl via Public IP
![apache2_curl_pub_ip.png](screenshots/apache2_curl_pub_ip.png)

<!---
 #![alt text for screen readers](/path/to/image.png "Text to show on mouseover").
-->

### Step 2 - Install MySql
Install mysql
- `sudo apt install mysql-server -y`
- `sudo mysql_secure_installation`

![mysql_installation.png](screenshots/mysql_security.png)

Access the mysql db
- `sudo mysql`
  
![mysql_verification.png](screenshots/mysql_verification.png)

### Step 3 - Install PHP
Install PHP
- `sudo apt -y install php libapache2-mod-php php-mysql`
- `php -v`

![php_verification](screenshots/php_install.png)


### Step 4 - Create a Virtual Host for Apache
Create a Virtual Host

![virtual_host_conf.png](screenshots/virtual_host_conf.png)
Enable the VirtualHost and update the index.html file with server details

![virtual_host_srv_details](screenshots/virtualhost_site_accessibility.png)


### Step 5 - Enable PHP on Website
Modify Apache precedence for php files
``` 
cat /etc/apache2/mods-enabled/dir.conf

<IfModule mod_dir.c>
        DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
```

Create index.php
```
cat /var/www/projectlamp/index.php
<?php
phpinfo();
```
![php_on_website.png](screenshots/php_on_website.png)
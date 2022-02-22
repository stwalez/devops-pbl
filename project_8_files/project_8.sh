#!/bin/bash

# Set hostname
sudo hostnamectl set-hostname load_balancer


# Install apache2
sudo apt update
sudo apt install apache2 -y
sudo apt-get install libxml2-dev -y

# Enable following modules:
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_balancer
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod lbmethod_bytraffic

# Restart apache2 service
sudo systemctl restart apache2

# Include the Proxy configuration in the site configuration VirtualHost section
<Proxy "balancer://mycluster">
			   BalancerMember http://<WebServer1-Private-IP-Address>:80 loadfactor=5 timeout=1
			   BalancerMember http://<WebServer2-Private-IP-Address>:80 loadfactor=5 timeout=1
			   ProxySet lbmethod=bytraffic
			   # ProxySet lbmethod=byrequests
		</Proxy>

		ProxyPreserveHost On
		ProxyPass / balancer://mycluster/
		ProxyPassReverse / balancer://mycluster/

# Verify config
tail -n 20 /etc/apache2/sites-available/000-default.conf

# Get Public IP of ec2 instance
curl -4 ident.me

# Add the web servers to /etc/hosts file
sudo bash -c 'echo "172.31.44.47 Web1" >> /etc/hosts'
sudo bash -c 'echo "172.31.39.171 Web2" >> /etc/hosts'
sudo bash -c 'echo "172.31.36.240 Web3" >> /etc/hosts'

#Update the proxy section and  Verify config
tail -n 20 /etc/apache2/sites-available/000-default.conf

#!/bin/bash

## mysql-client

# Set hostname, update OS and install mysql-client
sudo hostnamectl set-hostname mysql-client 
bash
sudo apt update
sudo apt install -y mysql-client

# Add mysql-server IP to the hostfile and test connectivity
sudo bash -c 'echo "172.31.16.179 mysql-server" >> /etc/hosts'

# Connect to the mysql server with the specified username and password
mysql -u example_user -p -h mysql-server
show databases;
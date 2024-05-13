#!/bin/bash
yum update -y

# Use amazon-linux-extras to install LEMP stack
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras enable php8.2

# Install the LEMP stack
sudo yum clean metadata && sudo yum install nginx -y
sudo yum clean metadata && sudo yum install yum install php-cli php-pdo php-fpm php-mysqlnd -y


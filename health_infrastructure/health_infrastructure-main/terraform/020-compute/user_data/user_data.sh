#!/bin/sh

# Update the system
sudo yum update -y
sudo yum install -y ruby wget

# Install the AWS CLI
cd /home/ec2-user
wget https://aws-codedeploy-eu-west-2.s3.eu-west-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo systemctl start codedeploy-agent

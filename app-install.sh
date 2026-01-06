#! /bin/bash

sudo yum install httpd -y
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo echo "This is the Saas application" > /var/www/html/index.html

sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

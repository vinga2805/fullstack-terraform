#!/bin/bash
sudo su
yum install httpd -y
echo "This is an application created from terraform" > /var/www/html/index.html
echo "I am alive" > /var/www/html/health.html
service httpd start
chkconfig httpd on

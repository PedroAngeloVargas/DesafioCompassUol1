#!/bin/bash
sudo su
apt-get update -y
apt-get upgrade -y
apt-get install -y nginx
chown ubuntu:ubuntu /var/www/html
cd /var/log
touch meu_script.log
cd /
systemctl start nginx
systemctl enable nginx
timedatectl set-timezone America/Sao_Paulo
apt-get install stress-ng -y
stress-ng --cpu 2 --cpu-load 30 --timeout 100s
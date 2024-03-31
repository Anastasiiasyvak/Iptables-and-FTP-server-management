#!/bin/bash

sudo apt-get update
sudo apt-get install -y net-tools nmap vsftpd

sudo iptables -A INPUT -p icmp --icmp-type 8 -j DROP

sudo useradd -m ftp_user -s /bin/bash
echo "MyFTPPass!" | sudo passwd --stdin ftp_user

sudo mkdir -p /home/ftp_user
sudo touch /home/ftp_user/1.txt
sudo touch /home/ftp_user/2.txt
echo "Hello World!" | sudo tee /home/ftp_user/1.txt
echo "Hello World!" | sudo tee /home/ftp_user/2.txt

IFS=',' read -r -a ip_addresses <<< "$1"
for ip_address in "${ip_addresses[@]}"; do
  sudo iptables -A INPUT -s "$ip_address" -p tcp --dport 21 -j ACCEPT
done
sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo systemctl start vsftpd
sudo systemctl enable vsftpd


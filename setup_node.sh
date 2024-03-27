#!/bin/bash

exec > /dev/null 2>&1

IFS=',' read -r -a ip_addresses <<< "$1"


for ip_address in "${ip_addresses[@]}"; do
  sudo  iptables -A INPUT -s "$ip_address" -p tcp --dport 21 -j ACCEPT
done


sudo iptables -A INPUT -p tcp --dport 21 -j DROP

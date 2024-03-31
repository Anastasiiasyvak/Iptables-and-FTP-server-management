#!/bin/bash

credentials_file="credentials.txt"

if [ ! -f "$credentials_file" ]; then
    echo "Error: credentials.txt file not found."
    exit 1
fi

# Я видаляю попередні правила iptables, щоб уникати дублювання
iptables -D INPUT -p tcp --dport 21 -j ACCEPT 2>/dev/null

echo "Enter authorization key for the connected IP address:"
read -r authorization_key

client_ip="$SOCAT_PEERADDR"

echo "Authorization key: $authorization_key"

if grep -q "$client_ip $authorization_key" "$credentials_file"; then
    iptables -A INPUT -s "$client_ip" -p tcp --dport 21 -j ACCEPT
    echo "Authorized IP address added to allow list for FTP access."
else
    iptables -D INPUT -s "$client_ip" -p tcp --dport 21 -j ACCEPT 2>/dev/null
    echo "Unauthorized IP address discarded from allow list for FTP access."
fi

#!/bin/bash

# Backup your config file
# sample file config: /etc/sysconfig/network-scripts/ifcfg-ens33
echo "Input your name network:"
read -r network_name

config_file="/etc/sysconfig/network-scripts/ifcfg-$network_name"
echo "Path your network config file: $config_file"

if [ -e "$config_file".bak ]; then
    echo "Backup file $config_file exist"
elif [ -e "$config_file" ]; then
    echo "Backup file config network"
    sudo cp "$config_file" "$config_file".bak
else
    echo "$config_file not found"
    exit 0
fi

# Get UUID of your host
get_UUID=$(nmcli connection show | grep "${network_name}" | awk '{print $2}')
echo "Your UUID: $get_UUID"

# Input parameter
echo "Input your address:"
read -r ip_add

echo "Input your prefix:"
read -r prefix

echo "input your gateway:"
read -r ip_gateway

echo "Input your DNS 1:"
read -r dns_1

echo "Input your DNS 2:"
read -r dns_2

ifc_file="
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no 
BOOTPROTO=none 
DEFROUTE=yes 
IPV4_FAILURE_FATAL=no 
IPV6INIT=yes 
IPV6_AUTOCONF=yes 
IPV6_DEFROUTE=yes 
IPV6_FAILURE_FATAL=no 
IPV6_ADDR_GEN_MODE=stable-privacy 
NAME=ens33 
UUID=$get_UUID
DEVICE=ens33 
ONBOOT=yes 
IPADDR=$ip_add
PREFIX=$prefix
GATEWAY=$ip_gateway
DNS1=$dns_1
DNS2=$dns_2
"
#echo "${ifc_file}"

# Update config file
sudo echo "${ifc_file}" > "$config_file"
cat "$config_file"

# Restart network service
echo "Restart network service"
sudo systemctl restart network.service

# Test Ping
echo "Test Ping"
ping -c 4 8.8.8.8
ping -c 4 google.com


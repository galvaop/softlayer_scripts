#!/bin/bash

source ~/.sl_env

# Setup ssh keys
if [ ! -e ~/.ssh/id_rsa ]; then
	echo "Private key does not exist. Generating."
	ssh-keygen
fi

echo "Checking if sshkey is in softlayer..."
if [ "`sl sshkey list  | grep $SSHKEY`" == "" ]; then
	echo "Key not present. Sending..."
	sl sshkey add $SSHKEY --file="~/.ssh/id_rsa.pub"
else
	echo "Key is there."
fi

CPU=1
RAM=1
DATACENTER="ams01"

read -p "Hostname: " HOSTNAME
read -p "Domain: " DOMAIN
read -p "Operating System: " OS
read -p "CPU: " CPU
read -p "RAM: " RAM

OPTIONS="-d $DATACENTER --hourly -n 100 --disk 25 --private -o $OS -k $SSHKEY"

echo "Using SL account:"
sl config show

echo "Estimated per machine cost:"
sl vs create --hostname $HOSTNAME --domain $DOMAIN --cpu $CPU --memory $RAM $OPTIONS --test

read -p "Continue (y/[n]): " P 

[ "$P" == "y" ] || ( echo "Cancelling..." ; exit )

echo "Provisioning host $HOSTNAME$i.$DOMAIN..."
sl vs create --hostname $HOSTNAME$i --domain $DOMAIN --cpu $CPU --memory $RAM $OPTIONS -y

sleep 2s
watch "sl vs list | grep $HOSTNAME"


#!/bin/bash

KEY="<keyname>"

# Setup ssh keys
if [ ! -e ~/.ssh/id_rsa ]; then
        echo "Private key does not exist. Generating."
        ssh-gen-key
fi

echo "Sending public key to softlayer..."
sl sshkey add $KEY --file="~/.ssh/id_rsa.pub"

read -p "Hostname: " HOSTNAME
DOMAIN="galvaop.net"
read -p "CPUs: " CPU
read -p "RAM: " RAM
read -p "Number of machines: " TOTAL

PROVISIONING_SCRIPT="<https url to provisioning script>"
OPTIONS="-d wdc01 --san --hourly -n 100 --disk 25 -o UBUNTU_LATEST -k $KEY -i $PROVISIONING_SCRIPT"

echo "Using SL account:"
sl config show

echo "Estimated per machine cost:"
sl vs create --hostname $HOSTNAME --domain $DOMAIN --cpu $CPU --memory $RAM $OPTIONS --test

for i in `seq 1 $TOTAL`; do
        echo "Provisioning host $HOSTNAME$i.$DOMAIN..."
        sl vs create --hostname $HOSTNAME$i --domain $DOMAIN --cpu $CPU --memory $RAM $OPTIONS -y
done

sleep 2s
watch "sl vs list"

#!/bin/bash
# Provision a centos server in softlayer then run post provisioning script 

# Provision server

DATACENTER="ams03"
HOSTNAME="galvaop"
DOMAIN="sldemo.com"
CPU="1"
RAM="1"
OS="ubuntu_latest"
BILLING="hourly"
NETWORK="100"
SSHKEY="<KEY>"
POSTINSTALL="<provisioning script>"
DISK="25"
OTHER_OPTIONS=""

echo "Using SL account:"
slcli config show

# Get a quote
echo "Estimated per machine cost:"
slcli vs create --domain $DOMAIN --hostname $HOSTNAME --cpu $CPU --memory $RAM --os $OS --datacenter $DATACENTER --billing $BILLING --network $NETWORK --disk $DISK --postinstall $POSTINSTALL --key $SSHKEY $OTHER_OPTIONS --test

# Create after confirm
slcli vs create --domain $DOMAIN --hostname $HOSTNAME --cpu $CPU --memory $RAM --os $OS --datacenter $DATACENTER --billing $BILLING --network $NETWORK --disk $DISK --postinstall $POSTINSTALL --key $SSHKEY $OTHER_OPTIONS

watch slcli vs list

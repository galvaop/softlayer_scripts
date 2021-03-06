#!/bin/bash
# Post-provisioning script for CENTOS
# Simple actions to keep a machine with really basic security

{
echo "Setting up firewall rules..."
# Delete first...
iptables -F 
iptables -X 
iptables -Z 
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -j LOG # Delete after entering production if it causes too much IO
iptables -P INPUT DROP

echo "Here are the fw rules..."
iptables -L -vn --line

echo "Saving rules..."
/sbin/service iptables save

echo "Not forgetting ipv6 - don't use for now..."
ip6tables -F
ip6tables -X
ip6tables -A INPUT -i lo -j ACCEPT
service ip6tables save

echo "Performing system update..."
yum -y update

echo "Installing pySLAPI..."
yum -y install pip-python
pip install softlayer
} | tee $0.log

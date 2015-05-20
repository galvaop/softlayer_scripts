#!/bin/bash
# Assuming ubuntu

{
echo "Setup firewall rules..."
iptables-restore <<EOT
*filter
:INPUT DROP 
:FORWARD ACCEPT 
:OUTPUT ACCEPT 
-A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -i eth0 -j ACCEPT
-A INPUT -p icmp -j ACCEPT
COMMIT
# Completed on Tue Jul  1 10:13:19 2014
EOT

echo "Update server..."
apt-get update
apt-get upgrade -y

echo "Install docker.io"
apt-get install -y docker.io

echo "Run mongodb docker container and expose port to the internet"
docker run -d --name mongo_edp -p 27017:27017 mongo
iptables -A INPUT -p tcp --dport 27017 -j LOG
iptables -A INPUT -p tcp --dport 27017 -j ACCEPT

} | tee $0.log

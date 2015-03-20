#!/bin/bash
# Prep for SAP HANA ENV
# Base on http://help.sap.com/hana/red_hat_enterprise_linux_rhel_6_5_configuration_guide_for_sap_hana_en.pdf
# Log all the work

{
echo "Setting up firewall rules..."
iptables -F
iptables -X
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -j LOG
iptables -P INPUT DROP

echo "Here are the rules..."
iptables -L -vn --line

echo "Saving firewall rules for next reboot..."
service iptables save

# Assuming we're on 6.6
echo "Downgrading redhat release to 6.5..."
sudo yum downgrade redhat-release -y

echo "Synchronizing clock..."
service ntpd stop
ntpdate servertime.service.softlayer.com
service ntpd start

echo "Checking if ntp is on... And turning it on"
chkconfig | grep ntpd
chkconfig ntpd on

echo "Setup ntpdate to adjust clock on reboot for larger drifts"
echo servertime.service.softlayer.com >> /etc/ntp/step-tickers
chkconfig ntpdate on

echo "Installing yum-version lock and security"
yum -y install yum-versionlock yum-security

echo "Checking versions..."
yum --showduplicates nss-softokn # <= 3.14.3-12.el6_5
yum --showduplicates nss-softokn-freebl # <= 3.14.3-12.el6_5
yum --showduplicates kernel # <= 2.6.32-431.29.2.el6
yum --showduplicates kernel-haders # <= 2.6.32-431.29.2.el6
yum --showduplicates kernel-firmware # <= 2.6.32-431.29.2.el6

echo "Creating versionlock file list..."
cat > /etc/yum/pluginconf.d/versionlock.list <<EOT
kernel-2.6.32-431.29.2.el6.*
kernel-firmware-2.6.32-431.29.2.el6.*
kernel-headers-2.6.32-431.29.2.el6.*
nss-softokn-freebl-3.14.3-12.el6_5.*
nss-softokn-3.14.3-12.el6_5.*
redhat-release-server-6Server-6.5.0.1.el6.*
EOT

echo "Performing security updates..."
yum -y --security update

echo "Installing base + xfsprogs..."
yum -y groupinstall base
yum -y install xfsprogs

echo "Installing x11-auth..."
yum install xorg-x11-xauth -y

echo "Updating kernel..."
yum -y update kernel kernel-firmware

echo "Installing kernel headers..."
yum -y install kernel-headers.x86_64

echo "Creating directories for hana mountpoints..."
mkdir -p /hana/{shared,data,log}
mkdir -p /usr/sap

echo "Stopping and disabling kdump..."
service kdump stop
chkconfig kdump off

echo "Stopping and disabling abrt related stuff..."
service abrtd stop
service abrt-ccpp stop
chkconfig abrtd off
chkconfig abrt-ccpp off

echo "Cleaning up old kernels..."
package-cleanup --oldkernels --count=1 -y

echo "Done. Rebooting..."
reboot

} | tee $0.log

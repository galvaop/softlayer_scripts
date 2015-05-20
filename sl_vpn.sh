#!/bin/bash

source ~/.sl_env

ARRAY="/home/ptg/bin/array/array_vpnc64"
HOST="vpn.ams01.softlayer.com"

# Kill the VPN
kill_vpn ()
{
        $ARRAY -stop
        echo "Resetting resolv.conf..."
	sudo restorecon -v /etc/resolv.conf 
        sudo kill -HUP `pidof dhclient`
}

# Start the VPN
start_vpn ()
{
        $ARRAY -hostname $HOST -username $USER -passwd $VPN_PASS &
}

# Decisions and actions
if [ `pidof array_vpnc64` ]; then
	echo "Array is running. Killing..."
	kill_vpn
else 
	echo "Array is not running. Starting..."
	start_vpn
	echo "Run me again to kill the VPN."
fi




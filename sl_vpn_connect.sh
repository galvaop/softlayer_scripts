#!/bin/bash

source sl_ptg_lib.sh

ARRAY="/home/ptg/bin/array/array_vpnc64"
USER="<vpn username>
PASS="<vpn password - no % or $ or else it won't work>"
HOST="vpn.ams01.softlayer.com"

if [ `pidof array_vpnc64` ]; then
	echo "Array is running. Killing..."
	kill_vpn
else 
	echo "Array is not running. Starting..."
	start_vpn
	echo "Run me again to kill the VPN."
fi



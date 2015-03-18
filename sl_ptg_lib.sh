#!/bin/bash
#
# Common library of functions for softlayer usage
# Will develop as we go along....


# VPN STUFF

# Kill VPN will reset the resolv.conf file as it usually is left in a bad state after the array network vpn client dies.
kill_vpn ()
{
        $ARRAY -stop
        echo "Resetting resolv.conf..."
        sudo echo >/etc/resolv.conf
        sudo kill -HUP `pidof dhclient`
}

start_vpn ()
{
	$ARRAY -hostname $HOST -username $USER -passwd $PASS &
}


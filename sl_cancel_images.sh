#!/bin/bash
# Be careful with this - you can kill a lot more than your machines....

devicenames="<devnamestring>"
devices=`mktemp`

echo "Canceling all devices in the list:"
sl vs list | grep $devicenames | tee $devices

ANS="n"
read -p "Are you sure [y/N]? " ANS
[ "$ANS" != "y" ] && echo "Aborting..." && exit

echo "Proceeding to cancel..."

killem=`cat $devices | awk {' print $7 '}`
for i in $killem
do
	sl vs cancel $i -y
done

watch "sl vs list | grep $devicenames" 

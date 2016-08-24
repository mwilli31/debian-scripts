#!/bin/bash

# Value kit num should be
KITNUM=$(blkid -s UUID -o value /dev/mmcblk0p5  | cut -c1-13)
KITNUMNET=$(blkid -s UUID -o value /dev/mmcblk0p5  | cut -c10-13)

# Set to true if hostname or adhoc network needs to change
SHOULDREBOOT="false"

# Compare current hostname to what hostname should be
while IFS='' read -r line
do
        if [ "$line" != "kit-$KITNUM" ]; then
            SHOULDREBOOT="true"
			echo "kit-$KITNUM" > /etc/hostname
			break
        fi
done < /etc/hostname

# String for beginning of adhoc network name
NETSTRING=""
# Number for adhoc network
NTNUM=""
# Set to true if network name does not match kit number
WRONGNET="false"
# Set to true if device is currently in adhoc mode
IN_ADHOC="false"

# check current wireless setup for adhoc mode and network name
while IFS='' read -r line
do
	# Substring of line being read
	NETSTRING=$(echo $line | cut -c1-14)
	NETNUM=$(echo $line | cut -c20-23)
    if [ "$NETSTRING" == "wireless-essid" ]; then
            
		# if adhoc number does not match current hostname, rewrite interfaces
		if [ "$NETNUM" != "$KITNUMNET" ]; then
			WRONGNET="true"
		fi
    fi
	
	# check if currently in adhoc mode
	if [ "$line" == "wireless-mode ad-hoc" ]; then
            IN_ADHOC="true"
    fi
done < /etc/network/interfaces

# change interfaces if in adhoc mode with the wrong network name
if [ "$IN_ADHOC" == "true" ] && [ "$WRONGNET" == "true" ]; then
    cat /predix/debian-scripts/adhoc-scripts/adhoc1.txt > /etc/network/interfaces
    echo "wireless-essid kit-$KITNUMNET-wireless" >> /etc/network/interfaces
    cat /predix/debian-scripts/adhoc-scripts/adhoc2.txt >> /etc/network/interfaces
    SHOULDREBOOT="true"
fi

# reboot if a change was made
if [ "$SHOULDREBOOT" == "true" ]; then
	reboot
fi

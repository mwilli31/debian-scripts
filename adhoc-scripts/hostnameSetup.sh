# Value kit num should be
KITNUM=$(blkid -s UUID -o value /dev/mmcblk0p5  | cut -c1-13)

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

# Check if adhoc-interfaces and interfaces (for wireless) are the same
if cmp -s /etc/network/interfaces /etc/network/interfaces-adhoc ; then
   # interfaces same as original flash image, check if this is kit flash image is from, else change interfaces-adhoc
   while IFS='' read -r line
	do
		# Substring of line being read
		NETSTRING=$(echo $line | cut -c1-14)
		NETNUM=$(echo $LINE | cut -c20-32)
        if [ "$NETSTRING" == "wireless-essid" ]; then
            
			# if adhoc number does not match current hostname, rewrite interfaces
			if [ "$NETNUM" == "$KITNUM" ]; then
				cat adhoc1.txt > /etc/network/interfaces
				echo "wireless-essid kit-$KITNUM-wireless" >> /etc/network/interfaces
				cat adhoc2.txt >> /etc/network/interfaces
				SHOULDREBOOT="true"
			fi
        fi
	done < /etc/hostname
fi

# reboot if a change was made
if [ "$SHOULDREBOOT" == "true" ]; then
	reboot
fi

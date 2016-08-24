#!/bin/bash
KITNUM=""
KITARG="false"
#Check for argument
while [ $# -gt 0 ]
do
        case "$1" in
                -k)
                        shift
                        KITNUM="$1"
						KITARG="true"
			shift
                        ;;
		*)
			shift
			break
			;;

        esac
done

# if kit number not passed as argument, find it
if [ "$KITARG" == "false" ]; then
	KITNUM=$(blkid -s UUID -o value /dev/mmcblk0p5  | cut -c10-13)
fi
cat adhoc1.txt > /etc/network/interfaces-adhoc
echo "wireless-essid kit-$KITNUM-wireless" >> /etc/network/interfaces-adhoc
cat adhoc2.txt >> /etc/network/interfaces-adhoc
cp /etc/network/interfaces-adhoc /etc/network/interfaces

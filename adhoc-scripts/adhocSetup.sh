#!/bin/bash
KITNUM=""
#Check for argument
while [ $# -gt 0 ]
do
        case "$1" in
                -k)
                        shift
                        KITNUM="$1"
			shift
                        ;;
		*)
			shift
			break
			;;

        esac
done
cat adhoc1.txt > /etc/network/interfaces-adhoc
echo "wireless-essid kit-$KITNUM-wireless" >> /etc/network/interfaces-adhoc
cat adhoc2.txt >> /etc/network/interfaces-adhoc
cp /etc/network/interfaces-adhoc /etc/network/interfaces

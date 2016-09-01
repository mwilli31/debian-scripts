#!/bin/bash

#Check if the kit exists
cd 
cd /
cd predix/predix-machine-drivers-edison
echo "Updating Drivers"
git fetch --all
git reset --hard origin/master
git pull origin master
echo "Updated Drivers"

KIT=""
KITARG="false"

#Check for argument
while [ $# -gt 0 ]
do
        case "$1" in
                -k)
                        shift
                        KIT="$1"
			shift
                        ;;
		*)
			shift
			break
			;;

        esac
done

while IFS='' read -r line
do
        if [ "$line" == "$KIT" ]; then
                KITARG="true"
        fi
		if [ "$KIT" == "help" ]; then
                echo "$line"
                KITARG="false"
        fi
done < /predix/predix-machine-drivers-edison/kits_offered.txt

if [ "$KITARG" == "false" ]; then
        echo "Kit argument -k required, use -k help for all options"
	exit 1
fi

echo "Installing $KIT"
cd 
cd /
cd predix/predix-machine-drivers-edison
echo "Install/$KIT/" >> .git/info/sparse-checkout
git read-tree -mu HEAD
chmod -R 777 *
cd Install/$KIT
./setup.sh

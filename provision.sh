#!/bin/bash
USERNAME=""
TOKEN=""
ID=""
KIT=""
USERARG="false"
TOKENARG="false"
IDARG="false"
KITARG="false"

#check for flowthings arguments
while [ $# -gt 0 ]
do
        case "$1" in
                -u)
                        shift
                        USERNAME="$1"
			USERARG="true"
			shift
                        ;;
                -t)
                        shift
                        TOKEN="$1"
			TOKENARG="true"
			shift
                        ;;
                -i)
                        shift
                        ID="$1"
			IDARG="true"
			shift
                        ;;
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

#Exit if any of the four required parameters are missing
if [ "$USERARG" == "false" ] || [ "$USERNAME" == "" ]; then
	echo "Username argument -u required"
	exit 1
fi
if [ "$TOKENARG" == "false" ] || [ "$TOKEN" == "" ]; then
        echo "Token argument -t required"
	exit 1
fi
if [ "$IDARG" == "false" ] || [ "$ID" == "" ]; then
        echo "ID argument -i required"
	exit 1
fi

#Check if the kit exists
cd /predix/predix-machine-drivers-edison
git fetch --all
git read-tree -mu HEAD
while IFS='' read -r line
do
        if [ "$line" == "$KIT" ]; then
                KITARG="true"
        fi
		if [ "$KIT" == "help" ]; then
                echo "$line"
        fi
done < /predix/predix-machine-drivers-edison/kits_offered.txt

if [ "$KITARG" == "false" ]; then
        echo "Kit argument -k required, use -k help for all options"
	exit 1
fi

cd /predix

echo "Update predix machine"
cd predix-machine-edison
git fetch --all
git reset --hard origin/master
git pull origin master
cd ..

echo "Update local asset"
cd predix-asset-local
git fetch --all
git reset --hard origin/master
git pull origin master
cd setupScripts
./mongoSetup.sh
./startMongo.sh
cd ..
cd ..



chmod -R 777 *
echo "Installing $KIT"
cd /predix/predix-machine-drivers-edison
echo "Install/$KIT/" >> .git/info/sparse-checkout
git read-tree -mu HEAD
cd Install/$KIT
./setup.sh

echo "Starting Services"
systemctl daemon-reload
systemctl start predix-machine
systemctl start mongoStart
systemctl start mongoServer

echo "Downloading and updating flowthings"
curl -vvv "https://bootstrap.flowthings.io/install_kit.sh?username=${USERNAME}&token=${TOKEN}&device_id=${ID}" | bash

systemctl enable predix-machine
systemctl enable mongoServer
systemctl enable mongoStart

echo "***Services running, provision complete***"



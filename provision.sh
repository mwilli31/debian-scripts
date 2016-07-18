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
			KITARG="true"
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
if [ "$KITARG" == "false" ] || [ "$KIT" == "" ]; then
        echo "Kit argument -k required"
	exit 1
fi

echo "Update predix machine"
cd predix-machine-edison
git pull origin master
cd ..

echo "Update python drivers"
cd predix-machine-drivers-edison
git pull origin master
cd ..

echo "Update local asset"
cd predix-asset-local
git pull origin master
cd setupScripts
./mongoSetup.sh
./startMongo.sh
cd ..
cd ..

echo "Downloading and updating flowthings"
curl -vvv "https://bootstrap.flowthings.io/install_kit.sh?username=${USERNAME}&token=${TOKEN}&device_id=${ID}" | bash

chmod -R 777 *
echo "Installing Starter Kit"
cd predix-machine-drivers-edison/Install
./StarterKitDriverInstall.sh

echo "Starting Services"
sudo systemctl daemon-reload
sudo systemctl start starter-sensor-pub
sudo systemctl start predix-machine
sudo systemctl start mongoStart
sudo systemctl start mongoServer
sudo systemctl enable starter-sensor-pub
sudo systemctl enable predix-machine
sudo systemctl enable mongoServer
sudo systemctl enable mongoStart

echo "***Services running, provision complete***"

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
			if [ "$KIT" == "intel.edison.grove.flower" ] || [ "$KIT" == "intel.edison.grove.roommonitor" ]; then
				KITARG="true"
			fi
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
if [ "$KITARG" == "false" ]; then
        echo "Kit argument -k required, must be intel.edison.grove.flower, intel.edison.grove.roommonitor"
	exit 1
fi

cd /predix

echo "Update predix machine"
cd predix-machine-edison
git fetch --all
git reset --hard origin/master
git pull origin master
cd ..

echo "Update python drivers"
cd predix-machine-drivers-edison
git fetch --all
git reset --hard origin/Driver_Registry
git pull origin Driver_Registry
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
if [ "$KIT" == "intel.edison.grove.flower" ]; then
	echo "Installing Flower Pot Kit"
	cd /predix/predix-machine-drivers-edison
	echo "Install/intel.edison.grove.flower/" >> .git/info/sparse-checkout
	git pull origin Driver_Registry
	cd Install/intel.edison.grove.flower
	./setup.sh
fi
if [ "$KIT" == "intel.edison.grove.roommonitor" ]; then
	echo "Installing Room Monitor Kit"
	cd /predix/predix-machine-drivers-edison
	echo "Install/intel.edison.grove.roommonitor/" >> .git/info/sparse-checkout
	git pull origin Driver_Registry
	cd Install/intel.edison.grove.roommonitor
	./setup.sh
fi

echo "Starting Services"
sudo systemctl daemon-reload
sudo systemctl start predix-machine
sudo systemctl start mongoStart
sudo systemctl start mongoServer

echo "Downloading and updating flowthings"
curl -vvv "https://bootstrap.flowthings.io/install_kit.sh?username=${USERNAME}&token=${TOKEN}&device_id=${ID}" | bash

sudo systemctl enable predix-machine
sudo systemctl enable mongoServer
sudo systemctl enable mongoStart

echo "***Services running, provision complete***"



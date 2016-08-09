#!/bin/bash

KITNUM=""
KITARG="false"
#check for kit number argument
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

#Exit if any of the four required parameters are missing
if [ "$KITARG" == "false" ] || [ "$KITNUM" == "" ]; then
	echo "Kit number argument -k required"
	exit 1
fi

#pre-provision script -- getting edison to base image
echo "Setting up Edison as Edge Device"

echo "Installing Java"
apt-get update
apt-get install openjdk-8-jdk
echo "Java Installed"

#intitial PredixMachine
mkdir /predix
scriptPath="$PWD"
cd /predix
echo "Git pull Predix Machine"
git clone https://github.com/mwilli31/predix-machine-edison.git

#intitial files for Python Drivers
echo "Git pull Python Drivers"
mkdir predix-machine-drivers-edison
cd predix-machine-drivers-edison
git init
git remote add -f origin https://github.com/mwilli31/predix-machine-drivers-edison.git
git config core.sparseCheckout true
echo "Install/DriverWriter.py" >> .git/info/sparse-checkout
echo "kits_offered.txt" >> .git/info/sparse-checkout
git pull origin Driver_Registry
cd ..

#Initial files for Local Asset
echo "Git pull Local Asset"
git clone https://github.com/mwilli31/predix-asset-local.git

echo "Git pull wifi setup"
git clone https://github.com/mwilli31/wifi-setup-edison.git

#Update permissions for future scripts to run without issue
chmod -R 777 *

#Set up framework for Local Asset by installing mongodb and creating SystemD files to start the REST client
echo "Setup Local Asset"
./predix-asset-local/setupScripts/setup.sh

#Change kit name
echo "kit-$KITNUM" > /etc/hostname

#Set up adhoc files
cd $scriptPath/adhoc-scripts
./adhocSetup.sh -k $KITNUM

#Install avahi and adhoc
sudo apt-get install -y --ignore-hold avahi-daemon netatalk
sudo apt-get install -y isc-dhcp-server
sudo apt-get install -y openssh-server

./dhcpdSetup.sh
ifdown wlan0
ifup wlan0

echo "***Done, Proceeding to Reboot***"
reboot
#end file

#!/bin/bash
#pre-provision script -- getting edison to base image
echo "Setting up Edison as Edge Device"


#Setup hosts to work with flowthings (temporary -- flowthings is working on this)
echo "*********************"
echo "Setup hosts"

echo "169.45.182.68 api.flowthings.io" >> /etc/hosts
echo "169.45.182.68 ws.flowthings.io" >> /etc/hosts
echo "169.45.182.68 auth.flowthings.io" >> /etc/hosts
echo "169.45.182.68 dev.flowthings.io" >> /etc/hosts
#temporary-end

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

#Set up adhoc files
cd $scriptPath
./adhocSetup.sh

#Install avahi and adhoc
sudo apt-get install -y --ignore-hold avahi-daemon netatalk
sudo apt-get install -y isc-dhcp-server
sudo apt-get install -y openssh-server

./dhcpdSetup.sh
ifdown wlan0
ifup wlan0

#create PredixMachine systemD file - will be started later
echo '[Unit]' > /etc/systemd/system/predix-machine.service
echo 'Description=Predix Machine' >> /etc/systemd/system/predix-machine.service
echo 'After=network.target' >> /etc/systemd/system/predix-machine.service
echo '' >> /etc/systemd/system/predix-machine.service
echo '[Service]' >> /etc/systemd/system/predix-machine.service
echo 'WorkingDirectory=/predix/predix-machine-edison/machine/bin/predix/' >>/etc/systemd/system/predix-machine.service
echo 'ExecStart=/bin/bash start_container.sh start' >> /etc/systemd/system/predix-machine.service
echo 'Restart=always' >> /etc/systemd/system/predix-machine.service
echo 'RestartSec=10' >> /etc/systemd/system/predix-machine.service
echo '' >> /etc/systemd/system/predix-machine.service
echo '[Install]' >> /etc/systemd/system/predix-machine.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/predix-machine.service

echo "***Done***"
#end file

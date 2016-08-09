#!/bin/bash

#provision predix machine

echo "Updating Predix Machine"
cd /predix/predix-machine-edison
git fetch --all
git reset --hard origin/master
git pull origin master
echo "Predix Machine updated"
./predix/debian-scripts/provision-scripts/pm_service_setup.sh
echo "Predix Machine Service Updated"
systemctl start predix-machine
systemctl enable predix-machine

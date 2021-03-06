#!/bin/bash
echo "Updating Local Asset"
cd
cd /
cd predix/predix-asset-local
git fetch --all
git reset --hard origin/master
git pull origin master
cd setupScripts
echo $(pwd)
./mongoSetup.sh
./startMongo.sh
echo "Local Asset updated"

echo "Starting Mongo Services"
systemctl start mongoStart
systemctl start mongoServer
systemctl enable mongoServer
systemctl enable mongoStart

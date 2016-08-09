#!/bin/bash

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

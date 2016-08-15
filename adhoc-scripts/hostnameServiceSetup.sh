#Create a system-D service to change adhoc network and hostname for new flashes
echo '[Unit]' > /etc/systemd/system/hostname-setup.service
echo 'Description=Hostname Setup' >> /etc/systemd/system/hostname-setup.service
echo 'After=network.target' >> /etc/systemd/system/hostname-setup.service
echo '' >> /etc/systemd/system/hostname-setup.service
echo '[Service]' >> /etc/systemd/system/hostname-setup.service
echo 'ExecStart=/bin/bash /predix/debian-scripts/adhoc-scripts/hostnameSetup.sh' >> /etc/systemd/system/hostname-setup.service
echo '' >> /etc/systemd/system/hostname-setup.service
echo '[Install]' >> /etc/systemd/system/hostname-setup.service
echo 'WantedBy=multi-user.target' >> /etc/systemd/system/hostname-setup.service

systemctl enable hostname-setup

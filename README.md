# Predix Setup Script
# Pre-provision
 
	1. Flash the Edison with jubilinux and allow time for the Edison to restart. When prompted, press Ctrl + D. When restarting is finished:
	
		login: root
		password: edison

	2. Create the predix directory
		
		mkdir /predix

	3. Set up wifi
	
		nano /etc/network/interfaces
		Place a # in front of auto usb0
		Delete the # in front of auto wlan0
		After wpa-ssid replace the text that follows with the name of your network
		After wpa-psk replace the text that follows with your network's password
		After editing press Ctrl + X, when prompted hit y then enter
		Use the command "ifup wlan0" to enable wifi
		
	5. Clone setup scripts:
		cd /predix
		mkdir debian-scripts
		cd debian-scripts
		git init
		git remote add -f origin https://github.com/mwilli31/debian-scripts.git
		git pull origin Driver_Registry

	6. Run the setup script, kit number will be the number used to connect to the kit with adhoc
		
		cd /predix/debian-scripts
		chmod 777 *
		./pre-provision.sh -k <kit number>

# Provision
	
	8a. Connect to the ad-hoc network(does not work for Windows). Wirelessly connect to the network kit-wireless through your computer. Then, ssh into the device.
	
		ssh root@kit-<kit number>.local
		The device password is "edison"
	
	b. If using windows connect to the ad-hoc network following these steps.
		
		**go to "Network and Sharing Center"
		**click "Set up a new connection or network"
		**double click "Manually connect to a wireless network"
		**enter the kit-wireless of the ad-hoc network (as shown by "netsh wlan show networks") into the "Network name" field
		**configure security settings accordingly
		**uncheck "Start this connection automatically" (important)
		**click "Next", then "Close"
		**netsh wlan set profileparameter kit-wireless connectiontype=ibss
		**netsh wlan connect kit-wireless
		**Use a bash to replicate the ssh in part a. or use putty 

	The above command will give the COM port of the connected Edison. In putty set your connection type to serial. Change serial line to the line from the mode.com command. Set the speed to 115200 then click open to connect.

	10. Connect to wifi

		cd /predix/wifi-setup-edison
		./setupWifi.sh -s *Network Name* -p *Network Password*

	11. Run the provision script, for a full list of kit types use help for kit type

		cd /predix
		./provision.sh -u *Flowthings Username* -t *Flowthings Token* -i *Flowthings Device ID* -k *kit type*


	12. Attach Grove Header and sensors according to https://github.com/mwilli31/predix-machine-drivers-edison.git, then restart the Edison

	13. Check if services are up

		systemctl status <kit specific service>
		systemctl status predix-machine
		systemctl status mongoStart
		systemctl status mongoServer
		

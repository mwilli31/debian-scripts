# Predix Setup Script
# Pre-provision - How to Use
 
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
		
4. Clone setup scripts:
	
	cd /predix
	
	mkdir debian-scripts
	
	cd debian-scripts
	
	git init
	
	git remote add -f origin https://github.com/mwilli31/debian-scripts.git
	
	git pull origin Driver_Developer

5. Run the setup script
		
	cd /predix/debian-scripts
	
	chmod 777 *
	
	./pre-provision.sh

# Pre-provision - Info

1. Uses a unique id (uuid for /dev/mmcblk0p5) and saves as kit number to be used for hostname and adhoc

2. Installs openjdk-8

3. Pulls down predix machine, driver directory, local asset and wifi setup.

		Only downloads a list of kits offered and driver writer for drivers

4. Sets up local asset framework, installs mongodb and creates SystemD files to start REST client

5. Changes hostname of kit to kit-<kit number>

6. Sets up adhoc network to be kit-<kit number>-wireless

7. Reboots the device for changes to take affect

# Provision
	
1a. Connect to the ad-hoc network(does not work for Windows). Wirelessly connect to the network kit-wireless through your computer. Then, ssh into the device.
	
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

2. Connect to wifi

	cd /predix/wifi-setup-edison
	
	./setupWifi.sh -s *Network Name* -p *Network Password*

	reboot

3. Run the provision script, for a full list of kit types use help for kit type

	cd /predix
	
	./provision.sh -u *Flowthings Username* -t *Flowthings Token* -i *Flowthings Device ID* -k *kit type*


4. Attach Grove Header and sensors according to https://github.com/mwilli31/predix-machine-drivers-edison/tree/Driver_Developer.git, then restart the Edison

5. Check if services are up

	systemctl status *kit specific service* (Check /predix/predix-machine-drivers-edison/Install/*kit name*/README.md for info on kit)
	
	systemctl status predix-machine
	
	systemctl status mongoStart
	
	systemctl status mongoServer
		
# Provision - Info

1. Accepts arguments -u <flowthings username> -t <flowthings track token> -i <flowthings track id> -k <kit type>

2. Provisions flowthings

	Takes in arguments and stops script if one is missing
		
	Sets up hosts for flowthings
		
	Downloads flowthings and sets up flowthings service using curl command

	Starts the service

3. Provisions drivers
	
	Updates current driver files (writer and list of offered kits)
		
	Accepts kit type, if not an offered type in offered_kits.txt, script stops
		
	If help is the kit type argument, all offered kit types are displayed
		
	Adds kit type to sparse-checkout (allows it to be pulled and updated)
		
	Runs setup script in kit type specific directory (/predix/predix-machine-drivers-edison/Install/<kit type>/setup.sh

	If new kits are added they should have their directory name added to offered_kits.txt and contain a setup.sh script to do all setup

	*Important* Make sure to keep help as the last kit in offered_kits.txt

	Setup will install driver specific dependencies (currently mraa and upm), create the driver, and create the service

	Starts the service

4. Provision predix machine

	Updates predix machine
		
	Writes the service for predix machine (contained in pm_service_setup.sh)

	Starts the service

5. Provision local asset
		
	Updates local asset
	
	Runs mongo setup and start

	Starts mongo services

6. Move logrotate

	Moves logrotate from cron.daily to cron.hourly so logs are rotated hourly

	This is necessary to keep file system from filling

7. Restarts all services
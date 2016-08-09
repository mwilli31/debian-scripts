#!/bin/bash
U_ARG=""
T_ARG=""
I_ARG=""
K_ARG=""

#check for flowthings arguments
while [ $# -gt 0 ]
do
        case "$1" in
                -u)
                        shift
                        U_ARG="$1"
			shift
                        ;;
                -t)
                        shift
                        T_ARG="$1"
			shift
                        ;;
                -i)
                        shift
                        I_ARG="$1"
			shift
                        ;;
                -k)
                        shift
                        K_ARG="$1"
			shift
                        ;;
		*)
			shift
			break
			;;

        esac
done

#provision flowthings
/predix/debian-scripts/provision-scripts/provision_flowthings.sh -u $U_ARG -t $T_ARG -i $I_ARG

#provision kit specific drivers
/predix/debian-scripts/provision-scripts/provision_drivers.sh -k $K_ARG

#provision predix machine
/predix/debian-scripts/provision-scripts/provision_predix_machine.sh

#provision local asset
/predix/debian-scripts/provision-scripts/provision_local_asset.sh

echo "Restarting Services"
systemctl daemon-reload
echo "***Services running, provision complete***"

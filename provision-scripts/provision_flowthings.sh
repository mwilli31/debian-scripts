#!/bin/bash
USERARG="false"
TOKENARG="false"
IDARG="false"
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

echo "Downloading and updating Flowthings"
curl -vvv "https://bootstrap.flowthings.io/install_kit.sh?username=${USERNAME}&token=${TOKEN}&device_id=${ID}" | bash
echo "Updated Flowthings"

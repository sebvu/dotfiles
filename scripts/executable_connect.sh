#!/bin/bash
# In the event nmcli dev wifi does not present any networks, attempt the following:
#
# sudo systemctl start wpa_supplicant.service
#
# in the event of a web browser authentication, enter http://neverssl.com into browser to complete authentication
#
# ACTIONS
#
# - Fix issue of auto-password having persisting error: connection activation failed: secrets were required, but not provided

kitty sh -c '

$HOME/scripts/set_wal.sh

exit_program () {
    echo "Press any key to exit."
    # -n 1 flag waits for a single character output
    # -s makes the input silent so it isnt displayed in terminal
    read -n 1 -s
}

cases () {

    NC="\033[0m"
    BOLD_CYAN="\033[1;36m"
    BOLD_RED="\033[1;31m"

    if [ "$1" = true ]; then
        # Awesome header!!
        echo -e "\n${BOLD_RED}🔥 Blazingly Fast Network Connector 🚀\n"
    else
        echo -e "\n${BOLD_RED}🔥 Choose Another Option? 🚀\n"
    fi

    echo -e "${BOLD_CYAN}c) Connect Wifi\nd) Disconnect From Wifi\nt) Untrust Wifi\ns) Wifi Speed Test\nn) neverssl.com authentication\n*) Quit${NC}"
    
    read -n 1 -s CHOICE

    case $CHOICE in 
        c)
            connect
            ;;
        d)
            disconnect
            ;;
        t)
            nmcli connection show
            check_match 
            untrust
            ;;
        s)
            speedtest
            ;;
        n)
            neverssl
            ;;
        *)
            exit_program
            ;;
    esac
}

check_match () {
    while true; do
        echo "Enter SSID:"
        # -r flag prevents backslashes from being interpreted as escape characters
        read -r NETWORK

        # "" will contain the entire content of the variable
        # -q silent output
        # -w greps has to match a whole word
        nmcli dev wifi | grep -q -w "$NETWORK"

        if [ $? -eq 1 ]; then
            echo "No match found."
            continue
        else
            break
        fi
    done
}

check_if_exists () {
    POTENTIAL_PASSWORD=$(cat $2 | grep $1 | sed 's/.*PASSWORD://')

    if [ -z "$POTENTIAL_PASSWORD" ]; then
        echo "No saved passwords found."
        return 2
    else
        echo -e "Password found. Do you wish to use it?\ny) Yes\n*) No"
        read -n 1 -s CHOICE
        case $CHOICE in
            y)
                nmcli dev wifi connect "$1" password "$POTENTIAL_PASSWORD"
                if [ $? -ne 0 ]; then
                    echo "Error: Failed to connect with saved password."
                    return 3
                else
                    echo "Already previously saved."
                    return 0
                fi
                ;;
            *)
                return 1
                ;;
        esac
    fi
}

connect () {
LIST="nmcli dev wifi"
PASSWORDS_PATH="$HOME/Documents/important-documents/passwords.txt" # path to save passwords

$LIST

check_match
check_if_exists $NETWORK $PASSWORDS_PATH

if [ $? -ne 0 ]; then 
    while true; do

        nmcli dev wifi connect "$NETWORK" --ask 

        if [ $? -ne 0 ]; then
            echo "Error Input"
        else
            break
        fi
    done

    # once password is successful, log password

    cat ${PASSWORDS_PATH} | grep -s "SSID: ${NETWORK} | PASSWORD: ${PASSWORD}"

    if [ $? -ne 0 ]; then
        # grab current location
        LOCATION=$(curl -s https://ipinfo.io/loc)
        # grab current date
        CURRENT_DATE=$(date +%m/%d/%y)
        # print to passwords.txt for storing
        $(echo "[${CURRENT_DATE} ${LOCATION}] SSID: ${NETWORK} | PASSWORD: ${PASSWORD}" >> ${PASSWORDS_PATH}) > /dev/null
        echo "SSID and password has been saved!"
    else
        echo "Already previously saved!"
    fi
fi

cases
}

disconnect () {
    SSID=$(nmcli -o | head -n1 | sed 's/.*to//')

    nmcli connection down id $SSID

    cases
}
untrust () {
    nmcli connection delete $1
    echo "Network has been removed from trusted networks."
    cases
}

speedtest () {
    speedtest-cli

    cases
}

neverssl () {
    xdg-open http://neverssl.com

    cases
}

cases true
'

exit 0

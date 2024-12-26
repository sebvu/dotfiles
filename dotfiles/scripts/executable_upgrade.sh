#!/bin/bash

# -c flag tells bash to read and execute commands inside quotes in new terminal
# alacritty -e bash -c '
kitty sh -c '

$HOME/scripts/set_wal.sh

update () {
    if sudo -v; then
        if [ "$OFFICIAL_UPDATES" -ne 0 ]; then
            sudo pacman -Sy && sudo pacman -Syu && sudo pacman -Fy
        fi
        if [ "$AUR_UPDATES" -ne 0 ]; then
            yay -Sy && yay -Syu
        fi
        if [ "$FLATPAK_UPDATES" -ne 0 ]; then
            flatpak upgrade
        fi
    fi
}

mirror_list () {
    if sudo -v; then
        # Backup mirrorlist
        sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak 

        # Pull the latest top 10 mirrors
        sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    fi

    main_prompt
}

print_packages () {
    # Print out # of packages to update

    echo -e $BOLD_CYAN

    echo "---Upgradeable Packages---"
    echo "[Official] $OFFICIAL_UPDATES"
    echo "[AUR] $AUR_UPDATES"
    echo "[Flatpak] $FLATPAK_UPDATES"
    echo "-------------------------"
    # No color
    echo -e $NC
}

main_prompt () {
    echo -e $BOLD_CYAN

    if [ "$UPDATES_AVAILABLE" = true ]; then
        echo "(a) Update All Packages"
    fi

    echo -e "(b) Update Mirror List\n(*) Quit"
    echo -e $NC
    read -n 1 -s CHOICE

    case $CHOICE in
        a)
            if [ "$UPDATES_AVAILABLE" = true ]; then
                echo -e "${BOLD_CYAN}Updating all packages...${NC}"
                update
            else 
                continue
            fi
            ;;
        b)
            echo -e "${BOLD_CYAN}Updating mirror list...${NC}"
            mirror_list
            ;;
        *)
            continue
            ;;
    esac
}

exit_program () {
    echo -e "${BOLD_CYAN}Press any key to exit.${NC}"
    # -n 1 flag waits for a single character output
    # -s makes the input silent so it isnt displayed in terminal
    read -n 1 -s
}

# Define Variables
# Get the number of updates available for official packages
OFFICIAL_UPDATES=$(checkupdates | wc -l)
# Get the number of updates available for AUR packages
AUR_UPDATES=$(yay -Qua | wc -l)
# Get the number of updates available for Flatpak packages
# FLATPAK_UPDATES=$(flatpak list | wc -l)
FLATPAK_UPDATES=$(flatpak remote-ls --updates | wc -l)
# Define colors
NC="\033[0m"
BOLD_CYAN="\033[1;36m"
BOLD_RED="\033[1;31m"
UPDATES_AVAILABLE=true
# Open new terminal emulator
fastfetch

# Awesome header!!
echo -e "\n${BOLD_RED}🔥 Blazingly Fast Updater 🚀 \n\n- made by sebvu, my first bash script!${NC}\n"

# Check if packages are available
if [ "$OFFICIAL_UPDATES" -eq 0 ] && [ "$AUR_UPDATES" -eq 0 ] && [ "$FLATPAK_UPDATES" -eq 0 ]; then
    echo -e "${BOLD_CYAN}No updates available.${NC}"
    UPDATES_AVAILABLE=false
else
    print_packages
fi

main_prompt
    
exit_program
'

exit 0




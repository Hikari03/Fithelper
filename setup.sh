#!/bin/bash

# Version: 23.04.20
# This is a setup script for my helper.sh script
# It will install helper.sh to /usr/local/bin
# and create a config file in /home/(username)/.config/fithelper

# Check if user is root
if [ "$(id -u)" != "0" ]; then
    echo -e "\033[1;31mThis script must be run as root\033[0m" 1>&2
    exit 1
fi

# Check if helper.sh is in the same directory as this script
if [ ! -f helper.sh ]; then
    echo -e "\033[1;31mhelper.sh not found in the same directory as this script\033[0m" 1>&2
    exit 1
fi

echo "Do you want full installation or just update? (full/update)"
read -r answer

if [ "$answer" = "update" ]; then
    echo "Updating..."
    cp helper.sh /usr/local/bin/fithelper
    chmod +x /usr/local/bin/fithelper
    echo "Done"
    exit 0
fi

# Install helper.sh
cp helper.sh /usr/local/bin/fithelper

# Create config file
mkdir /home/"${SUDO_USER:-${USER}}"/.config/fithelper 2>/dev/null
touch /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config

# Ask for config values
echo -e "\033[1;31mYou don't have to enter anything, but parts of script will not work.\033[0m"
echo -e "\033[1;31mIf you don't enter values, you can edit the config file in /home/${SUDO_USER:-${USER}}/.config/fithelper/config later, but default behaviour is undefined.\033[0m"
echo ''
echo -e "\033[1;35mEnter your CVUT username:\033[0;35m"
read -r DriveUser
echo ''
echo -e "\033[1;35mEnter your CVUT password:\033[0;35m"
read -r DrivePass
echo ''
echo -e "\033[1;35mEnter where your local directory will be (absolute path):\033[0;35m"
read -r LocalDir
echo ''
echo -e "\033[1;35mEnter where your mounted drive will be (absolute path):\033[0;35m"
read -r MountDir
echo ''
echo -e "\033[1;35mEnter your faculty PA2 git directory:\033[0;35m"
read -r FacultyPA2GitDir
echo ''
echo -e "\033[1;35mEnter your SAP directory on faculty drive:\033[0;35m"
read -r SAPRemoteDir
echo ''
echo -e "\033[1;35mEnter your PSI IDE directory:\033[0;35m"
read -r PSIIDEDir
echo ''
echo -e "\033[1;35mEnter your APS directory on faculty drive:\033[0;35m"
read -r APSRemoteDir

echo ''
echo -e "\033[0;35mThere are some default values, but you can change them later in /home/${SUDO_USER:-${USER}}/.config/fithelper/config\033[0m"
echo -e "\033[0;35mBy default, the script uses number of semester for subdirectories, but you can change it to something else.\033[0m"

# Write config values to config file
echo "#########################" > /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "######### CONFIG ########" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "#########################" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "DriveUser=\"$DriveUser\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "DrivePass=\"$DrivePass\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "LocalDir=\"$LocalDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "MountDir=\"$MountDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "FacultyPA2GitDir=\"$FacultyPA2GitDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "SAPRemoteDir=\"$SAPRemoteDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "PSIIDEDir=\"$PSIIDEDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "APSRemoteDir=\"$APSRemoteDir\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config

echo '' >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "#########################" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "##### DEFAULT VALUES ####" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "#########################" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "PA2SubDir=\"2\.Semestr/PA2\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "SAPSubDir=\"2\.Semestr/\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "PSISubDir=\"2\.Semestr/PSI\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
echo "APSSubDir=\"2\.Semestr/APS\"" >> /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config

# Create subdirectories
mkdir "$LocalDir"/2\.Semestr >/dev/null 2>&1
mkdir "$LocalDir"/2\.Semestr/PA2 >/dev/null 2>&1
mkdir "$LocalDir"/2\.Semestr/SAP >/dev/null 2>&1
mkdir "$LocalDir"/2\.Semestr/PSI >/dev/null 2>&1
mkdir "$LocalDir"/3\.Semestr/APS >/dev/null 2>&1

# Set permissions
chmod +x /usr/local/bin/fithelper
chmod +rw /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config

# Done
echo -e "\033[1;32mSetup complete. You can edit the config file in \033[1;31m/home/${SUDO_USER:-${USER}}/.config/fithelper/config\033[1;32m, if you need to.\033[0m"
echo -e "\033[1;32mRun \033[1;31mfithelper help\033[1;32m for more info.\033[0m"
echo -e "\033[1;32m┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\033[0m"
echo -e "\033[1;32m┃ \033[1;35mThank you for trying my script! :) \033[1;32m┃\033[0m"
echo -e "\033[1;32m┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\033[0m"

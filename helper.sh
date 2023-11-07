#!/bin/bash

GREEN="\033[0;32m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
BLUE="\033[1;34m"
RESET="\033[0m"

#########################
######### CONFIG ########
#########################

source /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
version="23.11.06"

#########################
####### FUNCTIONS #######
#########################

function mount() {
    nmcli con up id fit-vpn >/dev/null
    sudo mount.cifs //drive.fit.cvut.cz/home/"$DriveUser" "$MountDir" -o sec=ntlmv2i,file_mode=0700,dir_mode=0700,uid=$UID,user="$DriveUser",pass="$DrivePass" >/dev/null
}

function unmount() {
    sudo umount "$MountDir" >/dev/null
    nmcli con down id fit-vpn >/dev/null
}

function cpSap() {
    cp -ru "$MountDir"/Documents/SAP/* "$LocalDir"/"$SAPSubDir"
}

function syncGit() {
    cd "$LocalDir"              || (echo "cd to '$LocalDir' failed"; exit 1)
    git add *
    git commit
    git push
    cd -                        || (echo "IDK how you managed to do that, but cd to previous dir failed"; exit 1)
}

function cPa2() {
    cp -ru "$LocalDir"/"$PA2SubDir"/* "$FacultyPA2GitDir"
}

function syncGitPa2() {
    cd "$FacultyPA2GitDir"     || (echo "cd to '$FacultyPA2GitDir' failed"; exit 1)
    git add *
    git commit
    git push
    cd -                        || (echo "IDK how you managed to do that, but cd to previous dir failed"; exit 1)
}

function cpPsi() {
    cp "$PSIIDEDir"/main.py "$LocalDir"/"$PSISubDir"
}

function cpAPS() {
    cp -ru "$MountDir"/Documents/APS/* "$LocalDir"/"$APSSubDir"
}

function sinis() {
    nmcli con up id SIN
    ssh pride
    nmcli con down id SIN
}

function checkHttpCode() {
    httpCode="$(curl --max-time 5 --silent --write-out %{response_code} "$1" -o /dev/null)"
    if [ "$httpCode" -ne 200 ] && [ "$httpCode" -ne 301 ]; then
        echo -e "${RED}Error:${RESET} $1 ${BLUE}returned${RED} $httpCode${RESET}"
    else
        echo -e "${GREEN}OK:${RESET} $1 ${BLUE}returned${GREEN} $httpCode${RESET}"
    fi
}

function printHorSep() {
    echo -e "${BLUE}----------------------------------------${RESET}"
}

function pingServers() {
    echo -e "${BLUE}Checking internet connection...${RESET}"
    if ping -q -w 1 -c 1 8.8.8.8 > /dev/null 2>&1; then
        echo -e "${GREEN}OK: Internet connection is up${RESET}"
        printHorSep
        checkHttpCode "https://www.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://kos.cvut.cz/"
        printHorSep
        checkHttpCode "https://courses.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://online.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://marast.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://timetable.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://progtest.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://dbs.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://profile.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://grades.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://auth.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://gitlab.fit.cvut.cz/"
        printHorSep
        checkHttpCode "https://fit-wiki.cz/"
        printHorSep
    else
        echo -e "${RED}Error: Internet connection is down${RESET}"
        exit 1
    fi
}

# colorless version of checkHttpCode
function checkHttpCodeColorless() {
    httpCode="$(curl --max-time 5 --silent --write-out %{response_code} "$1" -o /dev/null)"
    if [ "$httpCode" -ne 200 ] && [ "$httpCode" -ne 301 ]; then
        echo -e "Error: $1 returned $httpCode"
    else
        echo -e "OK: $1 returned $httpCode"
    fi
}

# colorless version of printHorSep
function printHorSepColorless() {
    echo -e "----------------------------------------"
}

# colorless version of pingServers
function pingServersColorless() {
    echo "Checking internet connection..."
    if ping -q -w 1 -c 1 8.8.8.8 > /dev/null 2>&1; then
        echo "OK: Internet connection is up"
        printHorSepColorless
        checkHttpCodeColorless "https://www.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://kos.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://courses.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://online.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://marast.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://timetable.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://progtest.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://dbs.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://profile.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://grades.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://auth.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://gitlab.fit.cvut.cz/"
        printHorSepColorless
        checkHttpCodeColorless "https://fit-wiki.cz/"
        printHorSepColorless
    else
        echo "Error: Internet connection is down"
        exit 1
    fi
}

#########################
### DISPLAY FUNCTIONS ###
#########################

function displayWorking() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Working...' 6 20
}

function displayDone() {
    dialog  \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --msgbox 'Done' 6 20
}

function displayMounting() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Mounting...' 6 20
}

function displayUnmounting() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Copying SAP...' 6 20
}

function displayCopyingSAP() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Copying SAP...' 6 20
}

function displayCopyingAPS() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Copying APS...' 6 20
}

function displaySyncingGit() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Syncing git...' 6 20

    sleep 1
}

function displaySyncingFacGit() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Syncing faculty git...' 6 20

    sleep 1
}

function displayCopyingPA2() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Copying PA2...' 6 20
}

function displayCopyingPSI() {
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --infobox 'Copying PSI...' 6 20
}

function displayPingServers() { # Display server check from checkHttpCode
    dialog \
        --backtitle "FITHELPER GUI" \
        --title "FITHELPER" \
        --msgbox "$(pingServersColorless)" 20 70
}

#########################
######### GUI ###########
#########################

function GUI() {
    menu=(mount "Enable vpn and connect to faculty drive"
    unmount "Unmount drive and disable vpn"
    csap "Copy files from SAP to local dir"
    allsap "Do everything for SAP"
    syncgit "Commit and push to repo"
    cpa2 "Copy PA2 folder to faculty repo"
    syncgitpa2 "Commit and push PA2 to faculty repo"
    allpa2 "Do both above"
    psi "Copy PSI semester work to local dir"
    caps "Copy APS semester work to local dir"
    allaps "Do everything for APS"
    everything "DANGEROUS! DOES EVERYTHING!"
    sinis "ssh to sinis pride"
    ping "Check faculty services")

    choice=$(
    dialog --clear --keep-tite \
    --backtitle "FITHELPER GUI" \
    --title "FITHELPER" \
    --menu "      What can i do for you?" \
    20 60 10 \
    "${menu[@]}" \
    2>&1 >/dev/tty
    )

    if [[ -z $choice ]]; then
      echo 'No input...'
      exit 0
    fi

    displayWorking

    if [ "$choice" = 'mount' ]; then
      displayMounting
      mount

    elif [ "$choice" = 'unmount' ]; then
      displayUnmounting
      unmount

    elif [ "$choice" = 'csap' ]; then
      displayCopyingSAP
      cpSap

    elif [ "$choice" = 'allsap' ]; then
      displayMounting
      mount
      displayCopyingSAP
      cpSap
      displayUnmounting
      unmount

    elif [ "$choice" = 'syncgit' ]; then
      displaySyncingGit
      syncGit

    elif [ "$choice" = 'cpa2' ]; then
      displayCopyingPA2
      cPa2

    elif [ "$choice" = 'syncgitpa2' ]; then
      displaySyncingFacGit
      syncGitPa2

    elif [ "$choice" = 'allpa2' ]; then
      displayCopyingPA2
      cPa2
      displaySyncingFacGit
      syncGitPa2

    elif [ "$choice" = 'psi' ]; then
      displayCopyingPSI
      cpPsi

    elif [ "$choice" = 'caps' ]; then
      displayCopyingAPS
      cpAPS

    elif [ "$choice" = 'allaps' ]; then
      displayMounting
      mount
      displayCopyingAPS
      cpAPS
      displayUnmounting
      unmount

    elif [ "$choice" = 'sinis' ]; then
      sinis

    elif [ "$choice" = 'ping' ]; then
      displayPingServers

    elif [ "$choice" = 'everything' ]; then
      displayMounting
      mount
      displayCopyingSAP
      cpSap
      displayUnmounting
      cpPsi
      displayCopyingPA2
      cPa2
      displaySyncingGit
      syncGit
      displaySyncingFacGit
      syncGitPa2
      displayUnmounting
      unmount
    fi

    displayDone
}

#########################
######### MAIN ##########
#########################

if [ "$1" = 'mount' ] || [ "$1" = 'm' ]; then
    echo 'Mounting...'
    mount
    echo 'Done'

elif [ "$1" = 'unmount' ] || [ "$1" = 'un' ]; then
    echo 'Unmounting...'
    unmount
    echo 'Done'

elif [ "$1" = 'csap' ]; then
    echo 'Copying SAP...'
    cpSap
    echo 'Done'

elif [ "$1" = 'allsap' ]; then
    echo 'Mounting...'
    mount
    echo 'Copying SAP...'
    cpSap
    echo 'Unmounting...'
    unmount
    echo 'Done'

elif [ "$1" = 'syncgit' ] || [ "$1" = 's' ]; then
    echo 'Syncing git...'
    syncGit
    echo 'Done'

elif [ "$1" = 'cpa2' ]; then
    echo 'Copying PA2...'
    cPa2
    echo 'Done'

elif [ "$1" = 'syncgitpa2' ] || [ "$1" = 'sgpa2' ]; then
    echo 'Syncing PA2 git...'
    syncGitPa2
    echo 'Done'

elif [ "$1" = 'allpa2' ]; then
    echo 'Copying PA2...'
    cPa2
    echo 'Syncing PA2 git...'
    syncGitPa2
    echo 'Done'

elif [ "$1" = 'psi' ]; then
    echo 'Copying PSI...'
    cpPsi
    echo 'Done'

elif [ "$1" = 'caps' ]; then
    echo 'Copying APS...'
    cpAPS
    echo 'Done'

elif [ "$1" = 'allaps' ]; then
    echo 'Mounting...'
    mount
    echo 'Copying APS...'
    cpAPS
    echo 'Unmounting...'
    unmount
    echo 'Done'

elif [ "$1" = 'sinis' ] || [ "$1" = 'sin' ]; then
    sinis

elif [ "$1" = 'ping' ]; then
    pingServers

elif [ "$1" = 'everything' ]; then
    echo 'Mounting...'
    mount
    echo 'Copying SAP...'
    cpSap
    echo 'Copying PSI...'
    cpPsi
    echo 'Copying PA2...'
    cPa2
    echo 'Syncing git...'
    syncGit
    echo 'Syncing PA2 git...'
    syncGitPa2
    echo 'Unmounting...'
    unmount
    echo 'Done'

elif [ "$1" = 'gui' ] || [ "$1" = 'g' ]; then
    GUI

elif [ "$1" = 'help' ]; then
    echo 'Usage: fithelper [OPTION]'
    echo 'Helper script for CVUT FIT students'
    echo ''
    echo 'Options:'
    echo '  (g)ui                 Display GUI'
    echo '  ping                  Checks faculty services'
    echo '  (m)ount               Enable vpn and connect to faculty drive'
    echo '  (un)mount             Unmount drive and disable vpn'
    echo '  csap                  Copy files from SAP to local dir'
    echo '  allsap                Do everything for SAP'
    echo '  (s)yncgit             Commit and push to repo'
    echo '  cpa2                  Copy PA2 folder to faculty repo'
    echo '  syncgitpa2 (sgpa2)    Commit and push PA2 to faculty repo'
    echo '  allpa2                Do both above'
    echo '  psi                   Copy PSI semester work to local dir'
    echo '  caps                  Copy APS semester work to local dir'
    echo '  allaps                Do everything for APS'
    echo '  everything            DANGEROUS! DOES EVERYTHING!'
    echo '  help                  Display this help and exit'
    echo '  display_config        Display config'
    echo '  version               Display version'
    echo ''
    echo 'If there is any problem, please report it on github: https://github.com/Hikari03/fithelper'
    echo -e '\033[1;31mBefore doing so, try running "fithelper display_config" and check if your config is correct\033[0m'
    echo -e '\033[1;31mIf you are using GUI, try CLI commands first, as they display errors in more readable way\033[0m'
    echo -e '\033[1;32mAlso, if you have any idea for new feature, feel free to open issue\033[0m'

elif [ "$1" = 'display_config' ]; then
    cat /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config

elif [ "$1" = 'version' ]; then
     echo -e "Fithelper version $version"
     echo -e "Made with \033[1;31m<3 \033[0mby \033[1;35mDavid Houdek\033[0m"


else
    echo 'Invalid option, type "fithelper help" for more'
fi

exit 0

#!/bin/bash


#########################
######### CONFIG ########
#########################

source /home/"${SUDO_USER:-${USER}}"/.config/fithelper/config
version="23.10.02"

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
    everything "DANGEROUS! DOES EVERYTHING!" )

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

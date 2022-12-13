#!/bin/sh

echo "Welcome to ClanBot installer"
echo ""

root=$(pwd)
choice=9
    
base_url="https://github.com/TamaniWolf/bash-installer/blob/main"

script_menu="clan-menu.sh"
script_prereq="clan-prereq.sh"
script_install="clan-download.sh"
script_run="clan-run.sh"
script_run_pm2="clan-run-pm2.sh"

while [ $choice -eq 9 ]; do

    echo "1. Install Prerequisites"
    echo "2. Download ClanBot"
    echo "3. Run ClanBot in PM2"
    echo "4. Run ClanBot in Screen"
    echo "5. Exit"
    echo -n "Type in the number of an option and press ENTER"
    echo ""
    read choice

    if [[ $choice -eq 1 ]] ; then
        echo ""
        echo "Downloading the prerequisites installer script"
        rm "$root/$script_prereq" 1>/dev/null 2>&1
        wget -N "$base_url/$script_prereq" && bash "$root/$script_prereq"
        echo ""
        choice=9
    elif [[ $choice -eq 2 ]] ; then
        echo ""
        echo "Downloading the ClanBot installer script"
        rm "$root/$script_install" 1>/dev/null 2>&1
        wget -N "$base_url/$script_install" && bash "$root/$script_install"
        echo ""
        sleep 2s
        choice=9
    elif [[ $choice -eq 3 ]] ; then
        echo ""
        echo "Downloading the ClanBot run script for PM2"
        rm "$root/$script_run_pm2" 1>/dev/null 2>&1
        wget -N "$base_url/$script_run_pm2" && bash "$root/$script_run_pm2"
        echo ""
        sleep 2s
        bash "$root/clanStartScript.sh"
    elif [[ $choice -eq 4 ]] ; then
        echo ""
        echo "Downloading the ClanBot run script for screen"
        rm "$root/$script_run" 1>/dev/null 2>&1
        wget -N "$base_url/$script_run" && bash "$root/$script_run"
        echo ""
        sleep 2s
        bash "$root/clanStartScript.sh"
    elif [[ $choice -eq 6 ]] ; then
        echo ""
        echo "Exiting..."
        cd "$root"
        exit 0
    else
        echo "Invalid choice"
        echo ""
        choice=9
    fi
done

cd "$root"
exit 0

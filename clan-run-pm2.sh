#!/bin/sh
echo "Running ClanBot"
root=$(pwd)
choice=4
name="ClanBot"

base_url="https://raw.githubusercontent.com/TamaniWolf/bash-installer/main"

script_prereq="clan-prereq.sh"
script_install="clan-download.sh"
script_run="clan-run.sh"
script_run_pm2="clan-run-pm2.sh"

if hash pm2 2>/dev/null
then
    echo "PM2 installed."
else
    echo "PM2 is not installed."
    echo "Installing Prerequisites..."
    wget -N "$base_url/$script_prereq"
    bash "$root/$script_prereq"
    exit 1
fi

DIRECTORY="ClanBot"

if [ -d "$DIRECTORY" ]
then
  echo "$DIRECTORY is Downloaded."
else
    echo "$DIRECTORY is not Downloaded"
    echo "Downloading $DIRECTORY..."
    wget -N "$base_url/$script_install"
    bash "$root/$script_install"
    exit 1
fi

while [ $choice -eq 4 ]; do

    echo "1. Run PM2 without Auto Restarting ClanBot."
    echo "2. Run PM2 with Auto Restarting ClanBot."
    echo "3. Exit"
    echo ""
    echo "Choose:"
    echo "[1] to Run without Auto restart after crash/stop in PM2."
    echo "[2] to Run ClanBot with Auto Restart on crash/stop in PM2."
    read choice

    if [[ $choice -eq 1 ]] ; then
        echo "Do you want to name it?"
        read -p "[y/n]" yn
        case $yn in
            [Yy]* ) echo "Name:";;
            [Nn]* ) sleep 2; break;;
            * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
        esac
        if [[ $yn -eq y ]]; then
            read name
        elif [[ $yn -eq Y ]]; then
            read name
        fi
        echo ""
        echo "Running ClanBot without auto restart in PM2. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do pm2 start clanbot.js --name "$name" --max-memory-restart 250M; sleep 1s; done
        echo "Done"
    elif [[ $choice -eq 2 ]] ; then
        echo "Do you want to name it?"
        read -p "[y/n]" yn
        case $yn in
            [Yy]* ) echo "Name:";;
            [Nn]* ) sleep 2; break;;
            * ) echo "Couldn't get that please type [y] for Yes or [n] for No.";;
        esac
        if [[ $yn -eq y ]]; then
            read name
        elif [[ $yn -eq Y ]]; then
            read name
        fi
        echo ""
        echo "Running ClanBot with auto restart in PM2. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do pm2 start clanbot.js --name "$name" --max-memory-restart 250M && pm2 save; sleep 1s; done
        echo "Done"
    elif [[ "$choice" -eq 3 ]] ; then
        echo ""
        echo "Exiting..."
        cd "$root"
        exit 0
    else
        echo "Invalid choice"
        echo ""
        choice=4
    fi
done

cd "$root"
rm "$root/clan-run-pm2.sh"
exit 0

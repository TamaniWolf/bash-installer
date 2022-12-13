#!/bin/sh
echo "Running ClanBot"
root=$(pwd)
choice=4

if hash pm2 2>/dev/null
then
    echo "PM2 installed."
else
    echo "PM2 is not installed."
    echo "Installing Prerequisites..."
    bash "$root/clan_prereq.sh"
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
        echo ""
        echo "Running ClanBot without auto restart in PM2. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do pm2 start clanbot.js --name "ClanBot" --max-memory-restart 250M; sleep 5s; done
        echo "Done"
    elif [[ $choice -eq 2 ]] ; then
        echo ""
        echo "Running ClanBot with auto restart in PM2. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do pm2 start clanbot.js --name "ClanBot" --max-memory-restart 250M && pm2 save; sleep 5s; done
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

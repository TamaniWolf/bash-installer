#!/bin/sh
echo "Running ClanBot"
root=$(pwd)
choice=4

if hash screen 2>/dev/null
then
    echo "Screen installed."
else
    echo "Screen is not installed."
    echo "Installing Prerequisites..."
    bash "$root/clan_prereq.sh"
    exit 1
fi

while [ $choice -eq 4 ]; do

    echo "1. Run Screen without Auto Restarting ClanBot."
    echo "2. Run Screen with Auto Restarting ClanBot."
    echo "3. Exit"
    echo ""
    echo "Choose:"
    echo "[1] to Run without Auto restart after crash/stop in Screen."
    echo "[2] to Run ClanBot with Auto Restart on crash/stop in Screen."
    read choice

    if [[ $choice -eq 1 ]] ; then
        echo ""
        echo "Running ClanBot without auto restart in Screen. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do screen -dmS clanbot clanbot.js; sleep 5s; done
        echo "Done"
    elif [[ $choice -eq 2 ]] ; then
        echo ""
        echo "Running ClanBot with auto restart in Screen. Please wait. . ."
        cd "$root/ClanBot"
        sudo pnpm update
        while :; do screen -dmS clanbot clanbot.js; sleep 5s; done
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
rm "$root/clan-run.sh"
exit 0

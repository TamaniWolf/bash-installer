#!/bin/sh
echo ""
echo "Welcome to ClanBot."
echo "Downloading the latest installer..."
root=$(pwd)

rm "$root/clan-menu.sh" 1>/dev/null 2>&1
wget -N https://github.com/TamaniWolf/bash-installer/blob/main/clan-menu.sh

bash clan-menu.sh
cd "$root"
rm "$root/clan-menu.sh"
exit 0

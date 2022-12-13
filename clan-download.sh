#!/bin/sh

root=$(pwd)

# clone new version
git clone -b master --recursive --depth 1 https://github.com/TamaniWolf/ClanBot

cd "$root"
rm "$root/clan-download.sh"
exit 0

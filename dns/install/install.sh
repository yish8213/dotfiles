#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

# See https://www.maketecheasier.com/change-dns-servers-terminal-mac/
sudo networksetup -setdnsservers "Wi-Fi" 208.67.222.222 208.67.220.220
sudo networksetup -setdnsservers "Thunderbolt Ethernet" 208.67.222.222 208.67.220.220

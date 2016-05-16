#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)
brew bundle --file="$THIS_DIR/Brewfile"

find "$HOME/.ssh" \( -name *pem -o -name id_dsa -o -name id_rsa \) -exec sh -c 'chmod 600 "$0"' {} \;
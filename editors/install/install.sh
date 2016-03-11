#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"


# Install Atom plugins
## https://atom.io/packages/sync-settings
apm install sync-settings

## https://atom.io/packages/auto-update-packages
apm install auto-update-packages

## https://atom.io/packages/file-icons
apm install file-icons

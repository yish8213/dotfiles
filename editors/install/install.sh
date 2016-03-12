#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"


# Install Atom plugins
## https://atom.io/packages/sync-settings
if test ! -d "$HOME/.atom/packages/sync-settings"
then
  apm install sync-settings
fi

## https://atom.io/packages/auto-update-packages
if test ! -d "$HOME/.atom/packages/auto-update-packages"
then
  apm install auto-update-packages
fi

## https://atom.io/packages/file-icons
if test ! -d "$HOME/.atom/packages/file-icons"
then
  apm install file-icons
fi

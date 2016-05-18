#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)
brew bundle --verbose --file="$THIS_DIR/Brewfile"

# Install Atom plugins
while IFS='' read -r PLUGIN || [[ -n "$PLUGIN" ]]; do
  if test ! -d "$HOME/.atom/packages/$PLUGIN"
  then
    apm install $PLUGIN
  fi
done < "$THIS_DIR/atom-packages.txt"
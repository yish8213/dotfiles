#!/usr/bin/env bash

BREW_OS=$(uname -s)

case "$BREW_OS" in
    Darwin)
        echo "Running on macOS"
        BREW_OS='macos'
        ;;
    Linux)
        echo "Running on Linux"
        BREW_OS='ubuntu'
        ;;
    *)
        echo "Unknown OS"
        ;;
esac

sharedlist=$(find . -mindepth 1 -maxdepth 2 -type d -path "./shared/*" ! -path "./.*" | awk -F'/' '{print $NF}')
for package in $sharedlist
do
  stow -v --restow --dir=./shared --target="$HOME" --ignore="install*" "$package"
done
unset sharedlist;
unset package;

oslist=$(find . -mindepth 1 -maxdepth 2 -type d -path "./$BREW_OS/*" ! -path "./.*" | awk -F'/' '{print $NF}')
for package in $oslist
do
  stow -v --restow --dir="./$BREW_OS" --target="$HOME" --ignore="install*" "$package"
done
unset oslist;
unset package;
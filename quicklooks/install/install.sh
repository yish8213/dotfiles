#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)
brew bundle --verbose --file="$THIS_DIR/Brewfile"

# Install Markdown Quicklook
# ref: https://github.com/toland/qlmarkdown
defaults write com.apple.finder QLEnableTextSelection -bool TRUE; killall Finder

#!/usr/bin/env bash
#
# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true;
  do sudo -n true; sleep 60; kill -0 "$$" || exit;
done 2>/dev/null &

# Load the configurations
THIS_DIR=$(cd "$(dirname "$0")"; pwd)
source "$THIS_DIR/.config"

# Requirements for Homebrew on Ubuntu Linux.
if test "$BREW_OS" == "ubuntu"
then
  sudo apt update && sudo apt install build-essential procps curl file git -y && sudo apt autoremove --purge
fi

# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
## Ref: https://github.com/holman/dotfiles/blob/master/homebrew/install.sh
if test ! "$(which brew)"
then
  echo "Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to PATH
if test "$BREW_OS" == "ubuntu"
then
  (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Upgrade all the existing packages
brew update && brew upgrade

# Install the packages described in `Brewfile`
brew tap Homebrew/bundle
brew bundle

# Find the installers and run them iteratively
## Ref: https://github.com/holman/dotfiles/blob/master/script/install
find ./shared/ ./"$BREW_OS"/ -name install.sh | while read installer;
  do sh -c "chmod +x ${installer} && ${installer}";
done

# Remove outdated versions from the cellar.
brew cleanup

echo "Run GNU Stow"
# Treat the personal configurations first
if [ -f "$THIS_DIR/not-shared" ];
then
  stow --restow --target="$HOME" --ignore="install*" "not-shared"
fi

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

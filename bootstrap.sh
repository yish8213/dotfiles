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

# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
## Ref: https://github.com/holman/dotfiles/blob/master/homebrew/install.sh
if test ! $(which brew)
then
  echo "Installing Homebrew for you."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Upgrade all the existing packages
brew update && brew upgrade

# Install the packages described in `Brewfile`
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

brew tap Homebrew/bundle
brew bundle

# Find the installers and run them iteratively
## Ref: https://github.com/holman/dotfiles/blob/master/script/install
find . -name install.sh | while read installer;
  do sh -c "chmod +x ${installer} && ${installer}";
done

# Remove outdated versions from the cellar.
brew cleanup

# Run GNU Stow
# Treat the personal configurations first
if [ -f "$THIS_DIR/not-shared" ];
then
  stow --restow --target="$HOME" --ignore="install*" "not-shared"
fi

dirlist=$(find . -mindepth 1 -maxdepth 1 -type d ! -path "./.*" | awk -F'/' '{print $NF}')
for dir in $dirlist
do
  stow --restow --target="$HOME" --ignore="install*" "$dir"
done
unset dirlist;
unset dir;

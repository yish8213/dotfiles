#!/usr/bin/env bash
#
# ref: [Upgrade to bash 4 in Mac OS X](http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/)

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

if test ! -f /usr/local/bin/bash
then
  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
  # running `chsh`.
  brew bundle --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
  # Change to the new shell
  chsh -s /usr/local/bin/bash
fi

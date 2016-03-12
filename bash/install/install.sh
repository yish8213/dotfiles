#!/usr/bin/env bash
#
# ref: [Upgrade to bash 4 in Mac OS X](http://clubmate.fi/upgrade-to-bash-4-in-mac-os-x/)

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

THIS_SHELL='bash'

if test ! -f "/usr/local/bin/$THIS_SHELL"
then
  # Install Bash 4.
  brew bundle --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c "echo /usr/local/bin/$THIS_SHELL >> /etc/shells"

  # Change to the new shell
  if [ "$LOGIN_SHELL" == "$THIS_SHELL" ]
  then
    chsh -s "/usr/local/bin/$LOGIN_SHELL"
  fi
fi

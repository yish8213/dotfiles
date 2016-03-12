#!/usr/bin/env bash

THIS_DIR=$(cd "$(dirname "$0")"; pwd)

THIS_SHELL='zsh'

if test ! -f "/usr/local/bin/$THIS_SHELL"
then
  # Install Zsh.
  brew bundle --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c "echo /usr/local/bin/$THIS_SHELL >> /etc/shells"

  # Change to the new shell
  if [ "$LOGIN_SHELL" == "$THIS_SHELL" ]
  then
    chsh -s "/usr/local/bin/$LOGIN_SHELL"
  fi
fi

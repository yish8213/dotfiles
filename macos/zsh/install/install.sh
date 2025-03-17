#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

THIS_SHELL="zsh"
THIS_SHELL_PATH="/bin/$THIS_SHELL"
OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"

if test ! -f "$THIS_SHELL_PATH" && test ! -d "$OH_MY_ZSH_PATH"
then
  # Install Zsh shell.
  brew bundle --verbose --file="$THIS_DIR/Brewfile"

  # Add the new shell to the list of allowed shells
  sudo bash -c "echo $THIS_SHELL_PATH >> /etc/shells"
  
  # Clone the oh-my-zsh repository
  git clone https://github.com/ohmyzsh/ohmyzsh.git $OH_MY_ZSH_PATH
fi

# Change to the new shell
if [ "$LOGIN_SHELL" == "$THIS_SHELL" ] && [ "$THIS_SHELL_PATH" != "$(finger -l "$USER" | awk '/Shell/' | awk '{ print $4 }')" ]
then
  chsh -s "$THIS_SHELL_PATH"
fi

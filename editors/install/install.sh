#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"


# Install Atom plugins
while IFS='' read -r PLUGIN || [[ -n "$PLUGIN" ]]; do
  if test ! -d "$HOME/.atom/packages/$PLUGIN"
  then
    apm install $PLUGIN
  fi
done < "$THIS_DIR/atom-packages.txt"

# Install Vim plugins
VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if test ! -d "$VUNDLE_DIR"
then
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
else
  pushd "$VUNDLE_DIR" && git pull && popd
fi

vim +PluginInstall +PluginUpdate +PluginClean +qall

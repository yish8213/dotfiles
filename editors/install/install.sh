#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"


# Install Atom plugins
PLUGINS=(
  AtomicChar
  sync-settings
  auto-update-packages
  project-manager
  file-icons
  linter
  linter-docker
  linter-shellcheck
  linter-haproxy
  file-icons
  minimap
  expose
  git-time-machine
  todo-show
  terminal-plus
  recent-files-fuzzy-finder
  zentabs
  language-markdown
  )

for PLUGIN in "${PLUGINS[@]}"; do
  if test ! -d "$HOME/.atom/packages/$PLUGIN"
  then
    apm install $PLUGIN
  fi
done

# Install Vim plugins
VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if test ! -d "$VUNDLE_DIR"
then
  git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
else
  pushd "$VUNDLE_DIR" && git pull && popd
fi

vim +PluginInstall +PluginUpdate +PluginClean +qall

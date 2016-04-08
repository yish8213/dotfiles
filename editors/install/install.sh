#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"


# Install Atom plugins
## https://atom.io/packages/sync-settings
## https://atom.io/packages/auto-update-packages
## https://atom.io/packages/project-manager
## https://atom.io/packages/file-icons
## https://atom.io/packages/linter-shellcheck
PLUGINS=(
  sync-settings
  auto-update-packages
  project-manager
  file-icons
  linter
  linter-shellcheck
  )

for PLUGIN in "${PLUGINS[@]}"; do
  if test ! -d "$HOME/.atom/packages/$PLUGIN"
  then
    apm install $PLUGIN
  fi
done

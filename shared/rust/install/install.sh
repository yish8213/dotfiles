#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")" || exit; pwd)
brew bundle --verbose --file="$THIS_DIR/Brewfile"



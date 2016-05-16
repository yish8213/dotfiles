#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)
brew bundle --file="$THIS_DIR/Brewfile"

# http://rclone.org/install/
export GOPATH=$HOME/.rclone

if test ! -f "$GOPATH/bin/rclone"
then
  mkdir -p "$GOPATH/src" && go get github.com/ncw/rclone
fi

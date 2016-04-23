#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

brew bundle --file="$THIS_DIR/Brewfile"

# httpie
pip install httpie-oauth --upgrade

if which brew > /dev/null && [ -f `brew --prefix`/etc/bash_completion.d/httpie-completion.bash ]; then
    source `brew --prefix`/etc/bash_completion.d/httpie-completion.bash
fi

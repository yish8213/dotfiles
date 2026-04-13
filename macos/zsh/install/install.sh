#!/usr/bin/env bash
THIS_DIR=$(cd "$(dirname "$0")"; pwd)

# 1. Install packages via Homebrew (Zsh, iTerm2, etc.)
brew bundle --verbose --file="$THIS_DIR/Brewfile"

# 2. Install Oh-My-Zsh if not present
OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"

if [ ! -d "$OH_MY_ZSH_PATH" ]; then
  echo "Installing Oh-My-Zsh..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_PATH"
fi

# 3. Setup Homebrew Zsh as the default shell
if command -v brew >/dev/null 2>&1; then
  BREW_ZSH="$(brew --prefix)/bin/zsh"
  
  if [ -f "$BREW_ZSH" ]; then
    # Add the new shell to the list of allowed shells if missing
    if ! grep -q "^$BREW_ZSH$" /etc/shells; then
      echo "Adding $BREW_ZSH to /etc/shells..."
      echo "$BREW_ZSH" | sudo tee -a /etc/shells
    fi
    
    # Change to the new shell if it isn't currently the default
    if [ "$LOGIN_SHELL" == "zsh" ]; then
      CURRENT_SHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
      if [ "$CURRENT_SHELL" != "$BREW_ZSH" ]; then
        echo "Changing default shell to $BREW_ZSH..."
        chsh -s "$BREW_ZSH"
      fi
    fi
  fi
fi

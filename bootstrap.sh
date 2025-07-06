#!/usr/bin/env bash
#
# bootstrap.sh - Dotfiles installation script

set -o pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

#
# Ask for the administrator password upfront.
sudo -v || { log_error "Failed to get sudo access"; exit 1; }

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Load the configurations
readonly THIS_DIR=$(cd "$(dirname "$0")" && pwd)
readonly CONFIG_FILE="$THIS_DIR/.config"

if [[ ! -f "$CONFIG_FILE" ]]; then
    log_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# shellcheck source=.config
source "$CONFIG_FILE"

if [[ -z "$BREW_OS" ]]; then
    log_error "BREW_OS not set in configuration"
    exit 1
fi

# Install Ubuntu prerequisites if needed
install_ubuntu_prereqs() {
    if [[ "$BREW_OS" == "ubuntu" ]]; then
        log_info "Installing Ubuntu prerequisites..."
        if ! sudo apt update; then
            log_error "Failed to update package lists"
            return 1
        fi

        if ! sudo apt install -y build-essential procps curl file git; then
            log_error "Failed to install required packages"
            return 1
        fi

        sudo apt autoremove --purge -y || log_warn "Failed to autoremove packages"
    fi
}

# Install or verify Homebrew
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        log_info "Homebrew already installed"
        return 0
    fi

    log_info "Installing Homebrew..."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        log_error "Failed to install Homebrew"
        return 1
    fi
}

# Configure Homebrew PATH for Ubuntu
configure_brew_path() {
    if [[ "$BREW_OS" == "ubuntu" ]]; then
        local brew_shellenv='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

        if ! grep -q "linuxbrew" ~/.profile 2>/dev/null; then
            log_info "Adding Homebrew to PATH in ~/.profile"
            {
                echo
                echo "$brew_shellenv"
            } >> ~/.profile
        fi

        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# Update and install packages
install_packages() {
    log_info "Updating Homebrew..."
    brew update || { log_error "Failed to update Homebrew"; return 1; }

    log_info "Upgrading existing packages..."
    brew upgrade || log_warn "Some packages failed to upgrade"

    if [[ -f "$THIS_DIR/Brewfile" ]]; then
        log_info "Installing base packages from Brewfile..."
        brew bundle --file="$THIS_DIR/Brewfile" || log_warn "Some Brewfile packages failed to install"
    else
        log_warn "No Brewfile found"
    fi
}

# Run install scripts
run_installers() {
    local installer_count=0

    for dir in "shared" "$BREW_OS"; do
        if [[ ! -d "$THIS_DIR/$dir" ]]; then
            log_warn "Directory not found: $THIS_DIR/$dir"
            continue
        fi

        while IFS= read -r -d '' installer; do
            log_info "Running installer: $installer"
            chmod +x "$installer"

            if "$installer"; then
                log_info "Successfully ran: $installer"
                ((installer_count++))
            else
                log_error "Failed to run: $installer"
            fi
        done < <(find "$THIS_DIR/$dir" -name "install.sh" -print0)
    done

    log_info "Ran $installer_count installers"
}

# Stow packages with conflict handling
stow_packages() {
    local stow_args=(--restow --target="$HOME" --ignore="install*")

    # Handle personal configurations
    if [[ -d "$THIS_DIR/not-shared" ]]; then
        log_info "Stowing personal configurations..."
        if stow "${stow_args[@]}" "not-shared"; then
            log_info "Successfully stowed not-shared"
        else
            log_error "Failed to stow not-shared"
        fi
    fi

    # Stow shared packages
    if [[ -d "$THIS_DIR/shared" ]]; then
        log_info "Stowing shared packages..."
        while IFS= read -r -d '' package_dir; do
            local package_name=$(basename "$package_dir")
            log_info "Stowing shared package: $package_name"

            if stow --dir="$THIS_DIR/shared" "${stow_args[@]}" "$package_name"; then
                log_info "Successfully stowed: $package_name"
            else
                log_error "Failed to stow: $package_name"
            fi
        done < <(find "$THIS_DIR/shared" -mindepth 1 -maxdepth 1 -type d -print0)
    fi

    # Stow OS-specific packages
    if [[ -d "$THIS_DIR/$BREW_OS" ]]; then
        log_info "Stowing $BREW_OS packages..."
        while IFS= read -r -d '' package_dir; do
            local package_name=$(basename "$package_dir")
            log_info "Stowing $BREW_OS package: $package_name"

            if stow --dir="$THIS_DIR/$BREW_OS" "${stow_args[@]}" "$package_name"; then
                log_info "Successfully stowed: $package_name"
            else
                log_error "Failed to stow: $package_name"
            fi
        done < <(find "$THIS_DIR/$BREW_OS" -mindepth 1 -maxdepth 1 -type d -print0)
    fi
}

# Main execution
main() {
    log_info "Starting dotfiles bootstrap..."

    install_ubuntu_prereqs || log_error "Ubuntu prerequisites installation failed"
    install_homebrew || { log_error "Homebrew installation failed"; exit 1; }
    configure_brew_path
    install_packages || log_error "Package installation had issues"
    run_installers
    stow_packages

    log_info "Bootstrap completed!"
}

# Run main function
main "$@"

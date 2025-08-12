#!/usr/bin/env bash
#
# restow-only.sh - Restow dotfiles packages without installation

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

# Determine OS
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            echo "ubuntu"
            ;;
        *)
            log_error "Unknown OS: $(uname -s)"
            exit 1
            ;;
    esac
}

# Stow packages with proper error handling
stow_packages() {
    local brew_os="$1"
    local this_dir="$2"
    local stow_args=(--restow --target="$HOME" --ignore="install*")

    # Stow shared packages
    if [[ -d "$this_dir/shared" ]]; then
        log_info "Restowing shared packages..."
        while IFS= read -r -d '' package_dir; do
            local package_name=$(basename "$package_dir")
            log_info "Restowing shared package: $package_name"

            if stow --dir="$this_dir/shared" "${stow_args[@]}" "$package_name"; then
                log_info "Successfully restowed: $package_name"
            else
                log_error "Failed to restow: $package_name"
            fi
        done < <(find "$this_dir/shared" -mindepth 1 -maxdepth 1 -type d -print0)
    else
        log_warn "Shared directory not found: $this_dir/shared"
    fi

    # Stow OS-specific packages
    if [[ -d "$this_dir/$brew_os" ]]; then
        log_info "Restowing $brew_os packages..."
        while IFS= read -r -d '' package_dir; do
            local package_name=$(basename "$package_dir")
            log_info "Restowing $brew_os package: $package_name"

            if stow --dir="$this_dir/$brew_os" "${stow_args[@]}" "$package_name"; then
                log_info "Successfully restowed: $package_name"
            else
                log_error "Failed to restow: $package_name"
            fi
        done < <(find "$this_dir/$brew_os" -mindepth 1 -maxdepth 1 -type d -print0)
    else
        log_warn "OS directory not found: $this_dir/$brew_os"
    fi
}

# Main execution
main() {
    local brew_os
    local this_dir

    brew_os=$(detect_os)
    this_dir=$(cd "$(dirname "$0")" && pwd)

    log_info "Starting restow process for OS: $brew_os"

    if ! command -v stow >/dev/null 2>&1; then
        log_error "stow command not found. Please install GNU Stow first."
        exit 1
    fi

    stow_packages "$brew_os" "$this_dir"

    log_info "Restow completed!"
}

# Run main function
main "$@"
# AGENTS.md

## Repository conventions
- Keep shared dotfiles and install steps under `shared/`.
- Keep platform-specific dotfiles and install steps under `macos/`, `ubuntu/`, and `fedora/`.
- Each package directory should contain stowable files at its root and optional install assets under `install/`.
- When an `install/` directory exists, prefer the pair `install.sh` + `Brewfile`.
- `bootstrap.sh` installs top-level packages from `Brewfile`, then runs every `install.sh` found under `shared/` and the current platform directory, then stows packages.

## Platform mapping
- `macos` is selected on `uname -s = Darwin`.
- `ubuntu` is selected for Linux distros with `/etc/os-release` `ID=ubuntu` or `ID=debian`.
- `fedora` is selected for Linux distros with `/etc/os-release` `ID=fedora`.
- Linux platforms should share Homebrew path setup through `/home/linuxbrew/.linuxbrew/bin/brew shellenv`.

## Adding a new package
1. Decide whether the package belongs in `shared/` or an OS-specific directory.
2. Create `<scope>/<package>/` for stow-managed files.
3. If package installation is needed, add `<scope>/<package>/install/install.sh` and `<scope>/<package>/install/Brewfile`.
4. Keep `install.sh` small and consistent with the existing pattern:
   - resolve `THIS_DIR`
   - run `brew bundle --verbose --file="$THIS_DIR/Brewfile"`
5. Avoid changing unrelated package directories while adding a new platform.

## Adding a new Linux distro
1. Update `.config` to map the distro's `/etc/os-release` `ID` to a `BREW_OS` directory name.
2. Update `restow-only.sh` with the same distro detection rules.
3. Update `bootstrap.sh` prerequisites for the distro if package manager setup differs.
4. Add the matching top-level directory (for example `fedora/`) with at least `base/install/`.
5. Update `README.md` when supported platforms change.


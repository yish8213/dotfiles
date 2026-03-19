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
5. In each `Brewfile`, list only the directly needed packages; Homebrew resolves transitive dependencies automatically.
6. In each `Brewfile`, use `brew 'name'` for Homebrew formulae and `cask 'name'` for Homebrew casks.
7. Verify the exact package token and type before adding it:
   - `brew info --formula <name>` for formulae
   - `brew info --cask <name>` for casks
8. Prepare `install.sh` and `Brewfile`, but leave actual installation verification to the user. Agents should not treat package installation or runtime login/setup as completed unless the user confirms it.
9. Keep `shared/` packages Linux-safe. Do not add macOS GUI app casks under `shared/`; reserve those for `macos/` packages. Binary casks are acceptable in `shared/` only when they are verified to work in the Linux Homebrew environment.
10. Avoid changing unrelated package directories while adding a new platform.

## Adding a new Linux distro
1. Update `.config` to map the distro's `/etc/os-release` `ID` to a `BREW_OS` directory name.
2. Update `restow-only.sh` with the same distro detection rules.
3. Update `bootstrap.sh` prerequisites for the distro if package manager setup differs.
4. Add the matching top-level directory (for example `fedora/`) with at least `base/install/`.
5. Update `README.md` when supported platforms change.


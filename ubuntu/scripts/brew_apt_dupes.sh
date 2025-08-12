#!/usr/bin/env bash
set -euo pipefail

# ----- pre-checks -----
if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: brew not found" >&2; exit 1
fi
if ! command -v dpkg >/dev/null 2>&1; then
  echo "ERROR: dpkg not found (Ubuntu/Debian only)" >&2; exit 1
fi

BREW_PREFIX="$(brew --prefix)"
BREW_BIN_DIRS=()
for d in "$BREW_PREFIX/bin" "$BREW_PREFIX/sbin" /home/linuxbrew/.linuxbrew/bin /home/linuxbrew/.linuxbrew/sbin; do
  [[ -d "$d" ]] && BREW_BIN_DIRS+=("$d")
done
[[ ${#BREW_BIN_DIRS[@]} -gt 0 ]] || { echo "ERROR: no brew bin dir found" >&2; exit 1; }

# ----- collect brew commands -----
declare -A seen
declare -a cmds
for dir in "${BREW_BIN_DIRS[@]}"; do
  # Collect executable items including symbolic links
  while IFS= read -r -d '' f; do
    [[ -x "$f" ]] || continue
    cmd="$(basename "$f")"
    [[ -z "${seen[$cmd]+x}" ]] || continue
    seen[$cmd]=1
    cmds+=("$cmd")
  done < <(find "$dir" -maxdepth 1 -mindepth 1 \( -type f -o -type l \) -print0 2>/dev/null || true)
done

in_brew_path() {
  local path="$1"
  for dir in "${BREW_BIN_DIRS[@]}"; do
    [[ "$path" == "$dir/"* ]] && return 0
  done
  return 1
}

printf "%-24s %-48s %-48s %-24s\n" "COMMAND" "BREW_PATH" "SYSTEM_PATH" "APT_PACKAGE"
printf "%0.s-" {1..150}; echo

for cmd in "${cmds[@]}"; do
  # All candidate paths in PATH (external executables only)
  mapfile -t all_paths < <(type -a -p "$cmd" 2>/dev/null | awk '!seen[$0]++')
  [[ ${#all_paths[@]} -gt 0 ]] || continue

  brew_path=""
  sys_path=""

  for p in "${all_paths[@]}"; do
    if [[ -z "$brew_path" ]] && in_brew_path "$p"; then
      brew_path="$p"
      continue
    fi
    if [[ -z "$sys_path" ]] && ! in_brew_path "$p"; then
      sys_path="$p"
      break
    fi
  done

  # Output only when both exist (i.e., when there's a duplicate)
  if [[ -n "$brew_path" && -n "$sys_path" ]]; then
    real_sys="$(readlink -f "$sys_path" 2>/dev/null || echo "$sys_path")"
    apt_pkg="$(dpkg -S "$real_sys" 2>/dev/null | head -n1 | cut -d: -f1 || true)"
    [[ -z "$apt_pkg" ]] && apt_pkg="(not-apt or snap)"
    printf "%-24s %-48s %-48s %-24s\n" "$cmd" "${brew_path:0:48}" "${sys_path:0:48}" "${apt_pkg:0:24}"
  fi
done

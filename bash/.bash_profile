#!/usr/bin/env bash

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH"

for file in $HOME/bin/*; do
	[ -r "$file" ] && [ -d "$file" ] && export PATH="$file:$PATH";
done;
unset file;

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Every ~/.extra* files are being sourced.
for extra in $(find $HOME -mindepth 1 -maxdepth 1 \( -type f -o -type l \) -name ".extra*"); do
	source "$extra";
done;
unset extra;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal" killall;

# iTerm2 may be integrated with the unix shell so that it can keep track of your command history, current working directory, host name, and more--even over ssh. This enables several useful features.
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# autojump is a faster way to navigate your filesystem. It works by maintaining a database of the directories you use the most from the command line.
[[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . "$(brew --prefix)/etc/profile.d/autojump.sh"
# dotfiles
## Installation

You should clone the repository to your home directory. [GNU Stow is not going to work if you clone this to somewhere and create the symbolic link to it](https://unix.stackexchange.com/questions/246983/can-gnu-stow-use-a-stow-directory-that-is-a-symbolic-link).

```bash
git clone https://github.com/andromedarabbit/dotfiles.git "$HOME" && cd "$HOME/dotfiles" && ./bootstrap.sh
```

That's it!

## Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-26)) takes place.

Here's an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

## Add custom commands without creating a new fork
If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don't want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Mathias Bynens"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="mathias@mailinator.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It's probably better to [fork this repository](https://github.com/mathiasbynens/dotfiles/fork) instead, though.

## Thanks to…
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [xero/dotfiles](https://github.com/xero/dotfiles)
- [dotfiles.github.io](http://dotfiles.github.io/): Your unofficial guide to dotfiles on GitHub.
- [Using Git and Github to Manage Your Dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)

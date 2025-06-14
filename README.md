# dotfiles

You should clone the repository to your home directory. [GNU Stow is not going to work if you clone this to somewhere and create the symbolic link to it](https://unix.stackexchange.com/questions/246983/can-gnu-stow-use-a-stow-directory-that-is-a-symbolic-link).

```bash
mkdir ~/dotfiles
cd "$HOME/dotfiles" && git clone https://github.com/yish8213/dotfiles.git . && ./bootstrap.sh
```

That's it!

### Utils

```bash
unlink-all.sh     # remove all the symbolic links in the target directory
restow-only.sh    # run restow only
```

## Thanks to…
- [andromedarabbit/dotfiles](https://github.com/andromedarabbit/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [xero/dotfiles](https://github.com/xero/dotfiles)
- [dotfiles.github.io](http://dotfiles.github.io/): Your unofficial guide to dotfiles on GitHub.
- [Using Git and Github to Manage Your Dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
